#!/usr/bin/env ruby
# Idempotently installs the Codex repeat guard into ~/.codex.

require "fileutils"

REPO_DIR = File.expand_path(__dir__)
SOURCE_GUARD = File.join(REPO_DIR, "repeat_guard.rb")
TARGET_GUARD = File.expand_path("~/.codex/hooks/repeat_guard.rb")
CONFIG_PATH = File.expand_path("~/.codex/config.toml")
GUARD_COMMAND = "/usr/bin/ruby #{TARGET_GUARD}"

def backup_file(path, label)
  return nil unless File.exist?(path)

  backup = "#{path}.bak-#{label}-#{Time.now.strftime('%Y%m%d%H%M%S')}"
  FileUtils.cp(path, backup)
  backup
end

def set_top_level_key(lines, key, value)
  first_section = lines.index { |line| line.match?(/^\s*\[/) } || lines.length
  top = lines[0...first_section]
  rest = lines[first_section..] || []
  desired = "#{key} = \"#{value}\"\n"
  matches = top.each_index.select { |i| top[i].match?(/^\s*#{Regexp.escape(key)}\s*=/) }

  raise "duplicate top-level #{key} entries found; refusing to edit" if matches.length > 1

  changed = false
  if matches.length == 1
    if top[matches[0]] != desired
      top[matches[0]] = desired
      changed = true
    end
  else
    insert_at = top.index { |line| line.match?(/^\s*model\s*=/) }
    insert_at = insert_at ? insert_at + 1 : top.length
    top.insert(insert_at, desired)
    changed = true
  end

  [top + rest, changed]
end

def install_guard_script
  raise "missing source guard: #{SOURCE_GUARD}" unless File.exist?(SOURCE_GUARD)

  FileUtils.mkdir_p(File.dirname(TARGET_GUARD))
  source = File.read(SOURCE_GUARD)
  if File.exist?(TARGET_GUARD) && File.read(TARGET_GUARD) == source
    puts "guard already current: #{TARGET_GUARD}"
    return
  end

  backup = backup_file(TARGET_GUARD, "repeat-guard")
  File.write(TARGET_GUARD, source, mode: "w", perm: 0o755)
  File.chmod(0o755, TARGET_GUARD)
  puts "installed guard: #{TARGET_GUARD}"
  puts "backup: #{backup}" if backup
end

def install_config
  FileUtils.mkdir_p(File.dirname(CONFIG_PATH))
  File.write(CONFIG_PATH, "") unless File.exist?(CONFIG_PATH)

  text = File.read(CONFIG_PATH)
  if text.include?(GUARD_COMMAND)
    puts "repeat guard hook already configured; not adding another one"
    return
  end

  lines = text.lines
  lines, changed_approval = set_top_level_key(lines, "approval_policy", "never")
  lines, changed_sandbox = set_top_level_key(lines, "sandbox_mode", "danger-full-access")
  text = lines.join

  if text.match?(/^\[hooks\]\s*$/)
    backup = backup_file(CONFIG_PATH, "yolo-only")
    File.write(CONFIG_PATH, text)
    puts "updated YOLO settings in #{CONFIG_PATH}"
    puts "backup: #{backup}" if backup
    warn "existing [hooks] table found; add the PreToolUse snippet from codex-config-snippet.toml manually"
    return
  end

  hook_block = <<~TOML

    [hooks]
    PreToolUse = [
      { matcher = "always", hooks = [
        { type = "command", command = "#{GUARD_COMMAND}", async = false, timeout = 2, statusMessage = "Checking repeated Codex operation" }
      ] }
    ]
  TOML

  new_text = text.rstrip + hook_block + "\n"
  changed = changed_approval || changed_sandbox || new_text != File.read(CONFIG_PATH)
  if changed
    backup = backup_file(CONFIG_PATH, "codex-yolo-repeat-guard")
    File.write(CONFIG_PATH, new_text)
    puts "updated config: #{CONFIG_PATH}"
    puts "backup: #{backup}" if backup
  else
    puts "config already current: #{CONFIG_PATH}"
  end
end

install_guard_script
install_config
puts "restart Codex for the configuration to take effect"
