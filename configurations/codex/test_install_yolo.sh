#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
INSTALLER="$SCRIPT_DIR/install_yolo.sh"
TMP_HOME=$(mktemp -d "${TMPDIR:-/tmp}/codex-yolo-install-test.XXXXXX")

cleanup() {
  rm -rf "$TMP_HOME"
}
trap cleanup EXIT

test -f "$INSTALLER"
test -x "$INSTALLER"

HOME="$TMP_HOME" "$INSTALLER" >/tmp/codex-yolo-install-test-1.out
HOME="$TMP_HOME" "$INSTALLER" >/tmp/codex-yolo-install-test-2.out

CONFIG="$TMP_HOME/.codex/config.toml"
GUARD="$TMP_HOME/.codex/hooks/repeat_guard.rb"

test -x "$GUARD"
grep -q '^approval_policy = "never"$' "$CONFIG"
grep -q '^sandbox_mode = "danger-full-access"$' "$CONFIG"
grep -q '^PreToolUse = ' "$CONFIG"

if [ "$(grep -c 'repeat_guard.rb' "$CONFIG")" -ne 1 ]; then
  echo "repeat guard hook should be configured exactly once" >&2
  exit 1
fi

if ! grep -q 'already configured' /tmp/codex-yolo-install-test-2.out; then
  echo "second installer run should report an existing configuration" >&2
  exit 1
fi
