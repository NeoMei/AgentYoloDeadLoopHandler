#!/usr/bin/env bash
#
# opencode-yolo.sh — 一键启用 / 关闭 OpenCode YOLO 模式
#
# YOLO 模式: 所有操作自动放行，仅保留 doom_loop(死循环)兜底拦截，
# 并 deny 一组不可逆的危险命令。在追求速度的同时守住底线。
#
# 用法:
#   ./setup-yolo.sh              # 启用 YOLO 模式 (全局配置, 默认)
#   ./setup-yolo.sh -p           # 启用 YOLO 模式 (当前项目 ./opencode.json)
#   ./setup-yolo.sh --revert     # 还原到 YOLO 启用前的备份
#   ./setup-yolo.sh -p --revert  # 还原项目配置
#   ./setup-yolo.sh --status     # 查看当前权限状态
#   ./setup-yolo.sh -h           # 帮助
#
set -euo pipefail

CONFIG_DIR="${OPENCODE_CONFIG_DIR:-$HOME/.config/opencode}"
GLOBAL_CONFIG="$CONFIG_DIR/opencode.json"
PROJECT_CONFIG="./opencode.json"
BACKUP_SUFFIX=".yolo-backup"

TARGET="$GLOBAL_CONFIG"
SCOPE="全局 (global)"
REVERT=0
SHOW_STATUS=0

# ---------- 颜色 ----------
if [[ -t 1 ]]; then
  C_GREEN=$'\033[32m'; C_YELLOW=$'\033[33m'; C_RED=$'\033[31m'
  C_CYAN=$'\033[36m'; C_RESET=$'\033[0m'
else
  C_GREEN=""; C_YELLOW=""; C_RED=""; C_CYAN=""; C_RESET=""
fi

info()  { printf "%s==>%s %s\n" "$C_CYAN" "$C_RESET" "$*"; }
ok()    { printf "%s✓%s %s\n" "$C_GREEN" "$C_RESET" "$*"; }
warn()  { printf "%s!%s %s\n" "$C_YELLOW" "$C_RESET" "$*"; }
err()   { printf "%s✗%s %s\n" "$C_RED" "$C_RESET" "$*" >&2; }

usage() {
  sed -n '3,16p' "$0" | sed 's/^# \{0,1\}//'
}

# ---------- 参数解析 ----------
while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--project) TARGET="$PROJECT_CONFIG"; SCOPE="项目 (project)"; shift ;;
    -r|--revert)  REVERT=1; shift ;;
    -s|--status)  SHOW_STATUS=1; shift ;;
    -h|--help)    usage; exit 0 ;;
    *) err "未知参数: $1"; usage; exit 1 ;;
  esac
done

command -v node >/dev/null 2>&1 || { err "未找到 node，OpenCode 依赖 Node.js，请先安装。"; exit 1; }

BACKUP_FILE="${TARGET}${BACKUP_SUFFIX}"

# ---------- 查看状态 ----------
if [[ "$SHOW_STATUS" -eq 1 ]]; then
  info "当前配置文件: $TARGET"
  if [[ ! -f "$TARGET" ]]; then
    warn "配置文件不存在。"; exit 0
  fi
  node -e '
    const fs = require("fs");
    const cfg = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
    const p = cfg.permission || {};
    const star = p["*"] || "(未设置)";
    const doom = p.doom_loop || "(未设置)";
    console.log(`  "*"        = ${star}`);
    console.log(`  doom_loop  = ${doom}`);
    if (p.bash && typeof p.bash === "object") {
      console.log(`  bash deny  = ${Object.keys(p.bash).filter(k=>p.bash[k]==="deny").length} 条`);
    }
    console.log(star === "allow"
      ? "\n状态: YOLO 模式已启用"
      : "\n状态: YOLO 模式未启用");
  ' "$TARGET"
  exit 0
fi

# ---------- 还原 ----------
if [[ "$REVERT" -eq 1 ]]; then
  if [[ -f "$BACKUP_FILE" ]]; then
    cp "$BACKUP_FILE" "$TARGET"
    rm -f "$BACKUP_FILE"
    ok "已还原 $SCOPE 配置: $TARGET"
  else
    warn "未找到备份文件: ${BACKUP_FILE}，无可还原内容。"
  fi
  exit 0
fi

# ---------- 启用 YOLO ----------
mkdir -p "$(dirname "$TARGET")"

# 备份原配置（仅首次）
if [[ -f "$TARGET" && ! -f "$BACKUP_FILE" ]]; then
  cp "$TARGET" "$BACKUP_FILE"
  info "已备份原配置 -> $BACKUP_FILE"
fi

# 合并 YOLO 权限到配置（保留已有字段，不触碰任何密钥）
node -e '
  const fs = require("fs");
  const path = process.argv[1];
  let cfg = {};
  try {
    if (fs.existsSync(path)) {
      const raw = fs.readFileSync(path, "utf8");
      if (raw.trim()) cfg = JSON.parse(raw);
    }
  } catch (e) {
    console.error("配置文件解析失败，请检查 JSON 格式: " + e.message);
    process.exit(1);
  }
  cfg["$schema"] = cfg["$schema"] || "https://opencode.ai/config.json";
  cfg.permission = Object.assign(
    typeof cfg.permission === "object" && cfg.permission !== null ? cfg.permission : {},
    {
      "*": "allow",
      "doom_loop": "ask",
      "bash": Object.assign(
        typeof cfg.permission === "object" && cfg.permission !== null && typeof cfg.permission.bash === "object" ? cfg.permission.bash : {},
        {
          "rm -rf /": "deny",
          "rm -rf ~": "deny",
          "rm -rf ~/*": "deny",
          "dd if=* of=/dev/*": "deny",
          "mkfs": "deny",
          "shutdown": "deny",
          "reboot": "deny"
        }
      )
    }
  );
  fs.writeFileSync(path, JSON.stringify(cfg, null, 2) + "\n");
' "$TARGET"

ok "YOLO 模式已启用 [$SCOPE]"
echo
info "配置文件: $TARGET"
info "权限设置:"
echo '    "*"        → allow   (全部自动放行)'
echo '    doom_loop  → ask     (死循环兜底拦截)'
echo '    危险命令    → deny    (rm -rf / 等已封禁)'
echo
warn "安全提示: 仅在可信环境使用; 敏感信息(API key 等)切勿写入配置文件，"
warn "         请用 {env:VAR} 或 {file:~/.secrets/xxx} 引用。"
echo
info "如需还原: $0 --revert"
