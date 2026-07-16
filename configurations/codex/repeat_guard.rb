#!/usr/bin/env ruby
# Blocks repeated Codex hook payloads before they become command loops.

require "json"
require "digest"
require "fileutils"

WINDOW_SECONDS = Integer(ENV.fetch("CODEX_REPEAT_GUARD_WINDOW", "60"))
MAX_IN_WINDOW = Integer(ENV.fetch("CODEX_REPEAT_GUARD_LIMIT", "3"))
STATE_DIR = File.expand_path(ENV.fetch("CODEX_REPEAT_GUARD_STATE_DIR", "~/.codex/hook-state"))
STATE_FILE = File.join(STATE_DIR, "repeat_guard.jsonl")

VOLATILE_KEY = /\A(session_id|turn_id|item_id|hookRunId|hook_run_id|process_id|started_at|completed_at|timestamp|created_at|updated_at|traceparent|tracestate|approval_id|request_id)\z/i

def scrub(value)
  case value
  when Hash
    value.each_with_object({}) do |(key, child), out|
      next if key.to_s.match?(VOLATILE_KEY)

      out[key.to_s] = scrub(child)
    end.sort.to_h
  when Array
    value.map { |child| scrub(child) }
  else
    value
  end
end

def find_first(value, keys)
  case value
  when Hash
    value.each do |key, child|
      return child if keys.include?(key.to_s) && !child.nil? && child != ""
    end
    value.each_value do |child|
      found = find_first(child, keys)
      return found unless found.nil?
    end
  when Array
    value.each do |child|
      found = find_first(child, keys)
      return found unless found.nil?
    end
  end
  nil
end

def short_label(payload)
  return "non-json hook payload" unless payload.is_a?(Hash)

  event = find_first(payload, %w[hook_event_name eventName event_name])
  tool = find_first(payload, %w[tool_name toolName tool namespace recipient_name])
  command = find_first(payload, %w[command cmd])
  cwd = find_first(payload, %w[cwd working_directory workdir])

  parts = []
  parts << event if event
  parts << tool if tool
  parts << command if command
  parts << "cwd=#{cwd}" if cwd
  parts.empty? ? "repeated hook payload" : parts.join(" | ")
end

begin
  raw = STDIN.read
  payload = JSON.parse(raw)
  normalized = scrub(payload)
  fingerprint_source = JSON.generate(normalized)
  label = short_label(payload)
rescue StandardError
  fingerprint_source = raw.to_s
  label = "non-json hook payload"
end

begin
  FileUtils.mkdir_p(STATE_DIR)
  now = Time.now.to_i
  hash = Digest::SHA256.hexdigest(fingerprint_source)
  lock_path = STATE_FILE + ".lock"

  File.open(lock_path, File::RDWR | File::CREAT, 0o600) do |lock|
    lock.flock(File::LOCK_EX)

    entries = if File.exist?(STATE_FILE)
      File.readlines(STATE_FILE, chomp: true).map do |line|
        begin
          JSON.parse(line)
        rescue JSON::ParserError
          nil
        end
      end.compact
    else
      []
    end

    cutoff = now - [WINDOW_SECONDS * 4, 3600].max
    entries = entries.select { |entry| entry["ts"].to_i >= cutoff }
    recent_same = entries.count { |entry| entry["hash"] == hash && entry["ts"].to_i >= now - WINDOW_SECONDS }
    count = recent_same + 1

    entries << { "ts" => now, "hash" => hash, "label" => label }
    tmp = STATE_FILE + ".tmp"
    File.write(tmp, entries.map { |entry| JSON.generate(entry) }.join("\n") + "\n", mode: "w", perm: 0o600)
    File.rename(tmp, STATE_FILE)

    if count > MAX_IN_WINDOW
      reason = "repeat_guard blocked repeated operation: #{label} appeared #{count} times within #{WINDOW_SECONDS}s"
      puts JSON.generate({ "decision" => "block", "reason" => reason })
    end
  end
rescue StandardError => e
  warn "repeat_guard failed open: #{e.class}: #{e.message}"
end
