# Agent YOLO Dead Loop Handler

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Contributors](https://img.shields.io/badge/contributors-welcome-green.svg)](CONTRIBUTING.md)

🚀 **让 AI 开发更高效，更安全！**

这个项目专门为各种 AI 开发工具提供 YOLO 模式配置方案，让你既能享受自动化带来的速度，又能保持开发效率。

## 🎯 项目目标

- ✅ **最大化自动化**: 启用 YOLO 模式，减少手动确认
- ⚡ **提升开发效率**: 自动化常规操作，专注核心开发
- 📚 **统一配置方案**: 为不同 AI 工具提供标准化配置

## 🛠️ 支持的工具

### Claude Code
> ✅ 已完成配置和验证

### OpenCode  
> 🚧 配置文档待补充

### Codex
> ✅ 已完成 YOLO 模式和重复操作拦截配置

## 📖 使用指南

### Claude Code 配置

#### 1. YOLO 模式配置

在项目目录下创建 `.claude/settings.json`:

```json
{
  "permissions": {
    "defaultMode": "auto",
    "allow": [
      "Read",
      "Write",
      "Edit",
      "Bash",
      "LSP",
      "AskUserQuestion",
      "TaskCreate",
      "TaskUpdate",
      "Skill"
    ],
    "ask": []
  }
}
```

#### 2. 全局配置

如要在所有项目中启用 YOLO 模式，修改全局配置：

```bash
# 编辑全局配置
nano ~/.claude/settings.json
```

添加相同的配置内容。

#### 3. 工作原理

**YOLO 模式体验:**
- ✅ 所有操作立即执行
- ✅ 无需手动确认
- ✅ 完全自动化体验
- ✅ 最大化开发效率

**典型操作自动化:**
- 文件读写：`Read`, `Write`, `Edit`
- 命令执行：`Bash`
- 代码操作：`LSP`
- 任务管理：`TaskCreate`, `TaskUpdate`
- 技能调用：`Skill`

#### 4. 完整配置文件

参见 `configurations/claude-code/` 目录下的完整配置文件。

### Codex 配置

Codex 配置位于 [`configurations/codex/`](configurations/codex/)。

快速安装：

```bash
ruby configurations/codex/install_repeat_guard.rb
```

安装内容：

- 启用 `approval_policy = "never"`
- 启用 `sandbox_mode = "danger-full-access"`
- 安装 `PreToolUse` 重复操作拦截 hook
- 同一操作 60 秒内第 4 次重复时返回 `decision = "block"`

详细说明见 [`configurations/codex/README.md`](configurations/codex/README.md)。

## 🔧 安装和使用

### Claude Code

1. 复制配置文件到你的项目：
```bash
cp configurations/claude-code/complete-config.json /path/to/your/project/.claude/settings.json
```

2. 复制配置到全局设置（可选）：
```bash
cp configurations/claude-code/complete-config.json ~/.claude/settings.json
```

3. 重启 Claude Code 或重新加载配置

4. 开始享受 YOLO 模式！

## 🎨 配置选项说明

### 权限模式

| 模式 | 说明 | 推荐场景 |
|------|------|----------|
| `auto` | 自动批准所有操作 | 开发环境 |
| `normal` | 需要确认操作 | 生产环境 |
| `bypassPermissions` | 完全绕过权限 | 高级用户 |

### 自动批准的操作

| 操作 | 说明 | 用途 |
|------|------|------|
| `Read` | 文件读取 | 查看代码和文档 |
| `Write` | 文件写入 | 创建新文件 |
| `Edit` | 文件编辑 | 修改现有文件 |
| `Bash` | 命令执行 | 运行脚本和工具 |
| `LSP` | 代码智能 | 跳转定义和查找引用 |
| `TaskCreate/Update` | 任务管理 | 跟踪工作进度 |
| `Skill` | 技能调用 | 使用特定功能 |

## 🔍 示例场景

### 正常使用 ✅

```bash
# 这些操作都会立即执行
echo "test" > file.txt
cat file.txt
npm install
git status
```

### 自动化工作流 ✅

```bash
# 复杂操作序列也无缝执行
npm install
npm run build
git add .
git commit -m "Update project"
git push
```

### 开发环境典型场景 ✅

```bash
# 前端开发完整流程
npm install              # 安装依赖
npm run dev             # 启动开发服务器
# 编辑组件文件
# 重启服务器查看效果
npm run build          # 构建生产版本
npm test              # 运行测试
```

## 📂 项目结构

```
agentYoloDeadLoopHandler/
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── configurations/
│   ├── claude-code/
│   │   ├── README.md
│   │   ├── yolo-mode.json
│   │   └── complete-config.json
│   ├── opencode/
│   │   └── README.md (待补充)
│   └── codex/
│       ├── README.md
│       ├── repeat_guard.rb
│       ├── install_repeat_guard.rb
│       └── codex-config-snippet.toml
└── examples/
    ├── basic-usage.md
    └── advanced-scenarios.md
```

## 🛡️ 安全建议

1. **仅在可信环境中使用 YOLO 模式**
2. **定期检查配置文件**
3. **使用版本控制保护重要文件**
4. **敏感项目建议保持默认确认模式**

## 🔧 高级配置

### 环境特定配置

**开发环境 (完全自动):**
```json
{
  "permissions": {
    "defaultMode": "auto",
    "allow": ["Read", "Write", "Edit", "Bash", "LSP"],
    "ask": []
  }
}
```

**生产环境 (保守模式):**
```json
{
  "permissions": {
    "defaultMode": "normal",
    "allow": ["Read", "Write", "Edit"],
    "ask": ["Bash"]
  }
}
```

### 团队协作配置

**统一团队配置:**
```bash
# 将配置文件提交到项目仓库
git add .claude/settings.json
git commit -m "Add team YOLO mode config"
git push

# 团队成员拉取后自动应用
git pull
```

## 🤝 贡献指南

我们欢迎各种贡献！

### 待补充的内容

- [ ] OpenCode 配置文档
- [x] Codex 配置文档
- [ ] 更多 AI 工具配置
- [ ] 高级使用示例
- [ ] 性能优化建议

### 如何贡献

1. Fork 本项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

详细的贡献指南请查看 [CONTRIBUTING.md](CONTRIBUTING.md)

## 📝 License

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 🌟 Star History

如果这个项目对你有帮助，请给一个 ⭐️！

## 💬 讨论

- 有问题？在 [Issues](https://github.com/NeoMei/AgentYoloDeadLoopHandler/issues) 中提出
- 想讨论？在 [Discussions](https://github.com/NeoMei/AgentYoloDeadLoopHandler/discussions) 中交流

---

**让 AI 开发更快、更安全！** 🚀🛡️
