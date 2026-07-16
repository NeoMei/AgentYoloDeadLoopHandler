# Codex YOLO + Dead Loop Handler

This directory contains a Codex YOLO setup and a small `PreToolUse` repeat guard.

The guard is designed for local development environments where Codex is allowed to run without per-command approval, but repeated identical tool calls should be stopped before they become a loop.

## What It Does

- Enables Codex YOLO mode with:
  - `approval_policy = "never"`
  - `sandbox_mode = "danger-full-access"`
- Adds a `PreToolUse` hook that fingerprints each tool payload.
- Allows the same operation up to 3 times in 60 seconds.
- Blocks the 4th identical operation in that window with `decision = "block"`.
- Keeps only a short rolling JSONL state file under `~/.codex/hook-state/`.

## Files

| File | Purpose |
|------|---------|
| `repeat_guard.rb` | The hook script that detects repeated Codex tool payloads |
| `install_yolo.sh` | One-command installer for Codex YOLO mode and the repeat guard |
| `install_repeat_guard.rb` | Idempotent installer for `~/.codex/config.toml` |
| `codex-config-snippet.toml` | Manual config snippet for users who prefer editing TOML themselves |
| `test_install_yolo.sh` | Smoke test for the one-command installer |

## Quick Install

From the repository root:

```bash
configurations/codex/install_yolo.sh
```

Then restart Codex.

The installer:

- creates `~/.codex/hooks/repeat_guard.rb`
- backs up `~/.codex/config.toml`
- adds YOLO settings if missing
- adds a `PreToolUse` hook when no `[hooks]` table exists
- refuses to duplicate an existing repeat guard entry

If your config already has a `[hooks]` table, the installer stops and prints a manual snippet instead of trying to merge TOML automatically.

The shell entrypoint is intentionally small. It checks that Ruby is available and then delegates to `install_repeat_guard.rb`.

## Verify Installer

Run the smoke test:

```bash
configurations/codex/test_install_yolo.sh
```

The test uses a temporary `HOME`, installs twice, and confirms the hook is not duplicated.

## Manual Config

Add this to the top level of `~/.codex/config.toml`:

```toml
approval_policy = "never"
sandbox_mode = "danger-full-access"
```

Then add the hook:

```toml
[hooks]
PreToolUse = [
  { matcher = "always", hooks = [
    { type = "command", command = "/usr/bin/ruby ~/.codex/hooks/repeat_guard.rb", async = false, timeout = 2, statusMessage = "Checking repeated Codex operation" }
  ] }
]
```

Copy the guard script:

```bash
mkdir -p ~/.codex/hooks
cp configurations/codex/repeat_guard.rb ~/.codex/hooks/repeat_guard.rb
chmod +x ~/.codex/hooks/repeat_guard.rb
```

## Tuning

The guard can be tuned with environment variables:

| Variable | Default | Meaning |
|----------|---------|---------|
| `CODEX_REPEAT_GUARD_WINDOW` | `60` | Rolling time window in seconds |
| `CODEX_REPEAT_GUARD_LIMIT` | `3` | Allowed repeats before blocking |
| `CODEX_REPEAT_GUARD_STATE_DIR` | `~/.codex/hook-state` | State directory |

Example:

```bash
CODEX_REPEAT_GUARD_WINDOW=120 CODEX_REPEAT_GUARD_LIMIT=5 ruby ~/.codex/hooks/repeat_guard.rb
```

## Security Notes

YOLO mode is intentionally dangerous. Use it only in trusted local development, disposable worktrees, containers, or other externally sandboxed environments.

Do not commit real Codex runtime files such as:

- `~/.codex/auth.json`
- `~/.codex/logs_*.sqlite`
- `~/.codex/state_*.sqlite`
- `~/.codex/sessions/`
- `~/.codex/config.toml` if it contains private paths, tokens, or workspace-specific settings

This repository includes only reusable scripts and example snippets.
