# OpenCode 配置

## 🚀 YOLO 模式 + 死循环防护

为 [OpenCode](https://opencode.ai) 提供 YOLO 模式配置方案：所有操作自动放行，仅保留 `doom_loop`（死循环）兜底拦截，并 deny 一组不可逆的破坏性命令。在追求速度的同时守住底线。

> ✅ 已完成配置和验证

## 📋 配置文件说明

| 文件 | 说明 |
|------|------|
| `yolo-mode.json` | 纯 YOLO 模式配置，可直接复制使用 |
| `setup-yolo.sh` | 一键启用 / 关闭 / 还原 / 查看状态的脚本 |

## 🔧 快速开始

### 方式一：一键脚本（推荐）

```bash
# 启用 YOLO 模式（写入全局配置 ~/.config/opencode/opencode.json）
./setup-yolo.sh

# 仅在当前项目启用（写入 ./opencode.json）
./setup-yolo.sh -p

# 查看当前权限状态
./setup-yolo.sh --status

# 还原到启用前的配置
./setup-yolo.sh --revert
```

脚本特性：
- ✅ 自动备份原配置（`.yolo-backup` 后缀），`--revert` 一键还原
- ✅ 合并写入，**保留**配置中已有的其他字段（model / mcp / plugin 等）
- ✅ **不触碰任何密钥**，仅修改 `permission` 块
- ✅ 支持 `OPENCODE_CONFIG_DIR` 环境变量自定义配置目录

### 方式二：手动复制配置

```bash
# 复制到全局配置
mkdir -p ~/.config/opencode
cp yolo-mode.json ~/.config/opencode/opencode.json

# 或复制到项目级配置
cp yolo-mode.json /path/to/your/project/opencode.json
```

## ⚙️ 配置详解

核心配置只需这几行：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "*": "allow",
    "doom_loop": "ask"
  }
}
```

### 权限取值

| 取值 | 含义 |
|------|------|
| `"allow"` | 自动放行，无需确认 |
| `"ask"` | 每次询问用户确认 |
| `"deny"` | 直接拒绝，不可执行 |

### 字段说明

| 字段 | 设置 | 作用 |
|------|------|------|
| `"*"` | `"allow"` | 通配所有工具，全自动放行（YOLO 核心） |
| `doom_loop` | `"ask"` | 检测到死循环（重复无进展调用）时弹出确认，**这就是死循环处理器** |
| `bash.*` | `"deny"` | 封禁不可逆命令（`rm -rf /`、`mkfs`、`dd` 写设备等） |

### 精细化控制（可选）

如果只想对部分工具开 YOLO，其余保持询问：

```json
{
  "permission": {
    "edit": "allow",
    "write": "allow",
    "bash": {
      "*": "allow",
      "rm -rf *": "ask"
    },
    "webfetch": "ask",
    "doom_loop": "ask"
  }
}
```

OpenCode 的权限匹配支持**精确优先**：更具体的规则覆盖更宽泛的规则，所以 `bash.rm -rf *: ask` 会覆盖 `bash.*: allow`。

## 🎯 工作原理

### YOLO 模式
`"*": "allow"` 让 OpenCode 默认放行所有工具调用：
- ✅ 文件读写 / 编辑
- ✅ Bash 命令执行
- ✅ MCP 工具调用
- ✅ Web 请求、任务派发等

### 死循环防护（doom_loop）
`doom_loop: ask` 是本项目的核心。当 Agent 陷入重复调用却无实质进展时，OpenCode 会暂停并请求确认：

```
正常流程:  工具调用 → 放行 → 工具调用 → 放行 → ...  (全速)
触发防护:  ... → 检测到重复无进展 → ⏸ 弹出确认 → 你决定是否继续
```

配合 `bash` 下的破坏性命令 deny，构成「速度优先、底线兜底」的双层防护。

## 🔒 敏感信息处理

> ⚠️ **切勿在配置文件中明文写入 API key、token 等敏感信息！**

OpenCode 原生支持变量替换，密钥应放在独立的密钥文件中，配置里只保留引用：

```json
{
  "mcp": {
    "my-server": {
      "type": "local",
      "command": ["npx", "my-server"],
      "environment": {
        "API_KEY": "{file:~/.secrets/my_api_key}"
      },
      "headers": {
        "Authorization": "Bearer {env:MY_API_TOKEN}"
      }
    }
  }
}
```

推荐做法：
```bash
# 1. 密钥存入独立文件，收紧权限
mkdir -p ~/.secrets && chmod 700 ~/.secrets
echo "your-secret-key" > ~/.secrets/my_api_key
chmod 600 ~/.secrets/my_api_key

# 2. 配置里用 {file:...} 或 {env:...} 引用（见上例）

# 3. 把密钥目录加入全局 gitignore
echo "~/.secrets/" >> ~/.gitignore
```

支持的变量语法：
- `{env:VARIABLE_NAME}` — 引用环境变量
- `{file:~/.secrets/xxx}` — 引用文件内容

## 📁 配置位置与优先级

OpenCode 按以下顺序合并配置（后者覆盖前者同名字段）：

1. 远程配置（`.well-known/opencode`）
2. **全局配置** `~/.config/opencode/opencode.json`
3. 自定义配置（`OPENCODE_CONFIG` 环境变量）
4. **项目配置** `./opencode.json`
5. `.opencode/` 目录下的 agents/commands/plugins

YOLO 模式建议放在**全局配置**，所有项目通用；敏感项目可在项目级 `opencode.json` 里用更严格的 `permission` 覆盖。

## 🐛 故障排除

| 问题 | 解决 |
|------|------|
| 配置不生效 | 运行 `opencode debug config` 查看合并后的最终配置 |
| YOLO 太激进 | 把 `"*": "allow"` 改成具体工具，或给关键工具单独设 `"ask"` |
| 脚本报 `node not found` | OpenCode 依赖 Node.js，先安装 Node |
| 误删了配置 | `setup-yolo.sh --revert` 从 `.yolo-backup` 还原 |

## 🛡️ 安全建议

1. **仅在可信环境使用 YOLO 模式** —— 所有操作会自动执行
2. **破坏性命令保留 deny** —— `rm -rf /` 等已在默认配置封禁
3. **不要关闭 doom_loop** —— 它是你最后的自动化安全网
4. **密钥绝不入配置文件** —— 用 `{file:...}` / `{env:...}` 引用
5. **敏感项目用项目级配置覆盖** —— 在项目 `opencode.json` 里收紧权限

---

**OpenCode + YOLO 模式 = 极速且安全的自动化开发！** 🚀🛡️
