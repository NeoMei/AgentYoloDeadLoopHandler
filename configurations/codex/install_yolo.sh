#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
INSTALLER="$SCRIPT_DIR/install_repeat_guard.rb"

usage() {
  cat <<'USAGE'
Install Codex YOLO mode and the PreToolUse repeat guard.

Usage:
  configurations/codex/install_yolo.sh

This installs:
  - approval_policy = "never"
  - sandbox_mode = "danger-full-access"
  - ~/.codex/hooks/repeat_guard.rb
  - a PreToolUse hook that blocks repeated identical operations

Restart Codex after installation.
USAGE
}

case "${1:-}" in
  -h|--help)
    usage
    exit 0
    ;;
  "")
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac

if ! command -v ruby >/dev/null 2>&1; then
  echo "ruby is required but was not found in PATH" >&2
  exit 1
fi

if [ ! -f "$INSTALLER" ]; then
  echo "missing installer: $INSTALLER" >&2
  exit 1
fi

exec ruby "$INSTALLER"
