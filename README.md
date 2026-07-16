# Agent YOLO Dead Loop Handler

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Contributors](https://img.shields.io/badge/contributors-welcome-green.svg)](CONTRIBUTING.md)

🚀 **让 AI 开发更高效，更安全！**

这个项目专门为各种 AI 开发工具提供 YOLO 模式配置和死循环防护方案，让你既能享受自动化带来的速度，又有安全保护防止意外循环。

## 🎯 项目目标

- ✅ **最大化自动化**: 启用 YOLO 模式，减少手动确认
- 🛡️ **智能循环防护**: 检测并阻止重复操作和死循环
- 📚 **统一配置方案**: 为不同 AI 工具提供标准化配置

## 🛠️ 支持的工具

### Claude Code
> 详细的配置方法和最佳实践

### OpenCode  
> 🚧 配置文档待补充

### Codex
> 🚧 配置文档待补充

## 📖 使用指南

### Claude Code 配置

#### 1. YOLO 模式配置

在项目目录下创建 `.claude/settings.json`:

```json
{
  "approvalMode": "auto",
  "permissions": {
    "allowRead": true,
    "allowWrite": true,
    "allowBash": true,
    "allowEdit": true,
    "allowNetwork": true,
    "allowMCP": true,
    "allowAgent": true
  },
  "autoApprove": [
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
  "bashBehavior": "auto",
  "networkBehavior": "auto",
  "editBehavior": "auto"
}
```

#### 2. 死循环防护配置

```json
{
  "loopPrevention": {
    "enabled": true,
    "detectionWindow": 60,
    "maxSameOperationCalls": 3,
    "maxSimilarCalls": 5,
    "cooldownPeriod": 10,
    "blockOnPattern": [
      "same.*operation.*3.*times",
      "similar.*call.*5.*times"
    ]
  },
  "repetitionDetection": {
    "enabled": true,
    "trackOperations": true,
    "alertThreshold": 3,
    "blockThreshold": 5
  }
}
```

#### 3. 完整配置文件

参见 `configurations/claude-code/` 目录下的完整配置文件。

#### 4. 工作原理

**正常情况 (YOLO 模式):**
- ✅ 所有操作立即执行
- ✅ 无需手动确认
- ✅ 完全自动化体验

**死循环防护:**
- ⚠️ 60秒内相同操作超过3次 → 触发拦截
- ⚠️ 相似操作超过5次 → 触发拦截
- 🛡️ 10秒冷却期防止意外循环

### OpenCode 配置

> 📝 配置文档待发布
> 
> 位置预留：`configurations/opencode/`

### Codex 配置

> 📝 配置文档待发布
>
> 位置预留：`configurations/codex/`

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
│   │   ├── loop-prevention.json
│   │   └── complete-config.json
│   ├── opencode/
│   │   └── README.md (待补充)
│   └── codex/
│       └── README.md (待补充)
└── examples/
    ├── basic-usage.md
    └── advanced-scenarios.md
```

## 🔧 安装和使用

### Claude Code

1. 复制配置文件到你的项目：
```bash
cp configurations/claude-code/complete-config.json /path/to/your/project/.claude/settings.json
```

2. 重启 Claude Code 或重新加载配置

3. 开始享受 YOLO 模式 + 死循环防护！

## 🎨 配置选项说明

### 基础权限

| 权限 | 说明 | 推荐设置 |
|------|------|----------|
| `allowRead` | 文件读取 | `true` |
| `allowWrite` | 文件写入 | `true` |
| `allowBash` | 命令执行 | `true` |
| `allowEdit` | 文件编辑 | `true` |
| `allowNetwork` | 网络请求 | `true` |

### 循环防护参数

| 参数 | 默认值 | 说明 |
|------|--------|------|
| `detectionWindow` | 60秒 | 检测窗口时间 |
| `maxSameOperationCalls` | 3次 | 相同操作最大次数 |
| `cooldownPeriod` | 10秒 | 冷却期时长 |
| `blockThreshold` | 5次 | 拦截阈值 |

## 🔍 示例场景

### 正常使用 ✅

```bash
# 这些操作都会立即执行
echo "test" > file.txt
cat file.txt
npm install
git status
```

### 触发防护 ⚠️

```bash
# 60秒内连续执行相同操作
echo "test" > file.txt  # 第1次 - OK
echo "test" > file.txt  # 第2次 - OK
echo "test" > file.txt  # 第3次 - OK
echo "test" > file.txt  # 第4次 - 被拦截！
```

## 🛡️ 安全建议

1. **仅在可信环境中使用 YOLO 模式**
2. **定期检查配置文件**
3. **使用版本控制保护重要文件**
4. **敏感项目建议保持默认确认模式**

## 🤝 贡献指南

我们欢迎各种贡献！

### 如何贡献

1. Fork 本项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

### 待补充的内容

- [ ] OpenCode 配置文档
- [ ] Codex 配置文档
- [ ] 更多 AI 工具配置
- [ ] 高级使用示例
- [ ] 性能优化建议

## 📝 License

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 🌟 Star History

如果这个项目对你有帮助，请给一个 ⭐️！

## 💬 讨论

- 有问题？在 [Issues](https://github.com/yourusername/agentYoloDeadLoopHandler/issues) 中提出
- 想讨论？在 [Discussions](https://github.com/yourusername/agentYoloDeadLoopHandler/discussions) 中交流

---

**让 AI 开发更快、更安全！** 🚀🛡️