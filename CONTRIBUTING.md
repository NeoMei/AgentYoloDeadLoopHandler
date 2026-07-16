# 贡献指南

感谢你考虑为 agentYoloDeadLoopHandler 项目做出贡献！🎉

## 🌟 如何贡献

### 报告问题

如果你发现了 bug 或有功能建议：

1. 检查 [Issues](https://github.com/yourusername/agentYoloDeadLoopHandler/issues) 确保问题未被报告
2. 创建新 Issue，详细描述：
   - 问题和复现步骤
   - 预期行为 vs 实际行为
   - 环境信息（OS、AI工具版本等）
   - 相关配置和日志

### 提交代码

#### 1. Fork 项目

点击 GitHub 页面右上角的 Fork 按钮

#### 2. 克隆你的 Fork

```bash
git clone https://github.com/YOUR_USERNAME/agentYoloDeadLoopHandler.git
cd agentYoloDeadLoopHandler
```

#### 3. 创建特性分支

```bash
git checkout -b feature/your-feature-name
# 或
git checkout -b fix/your-bug-fix
```

#### 4. 进行更改

- 遵循现有代码风格
- 添加必要的测试
- 更新相关文档

#### 5. 提交更改

```bash
git add .
git commit -m "feat: add new feature"
# 或
git commit -m "fix: resolve issue #123"
```

#### 6. 推送到你的 Fork

```bash
git push origin feature/your-feature-name
```

#### 7. 创建 Pull Request

- 访问你的 Fork 页面
- 点击 "New Pull Request"
- 填写 PR 描述模板
- 等待 review 和合并

## 📋 开发指南

### 项目结构

```
agentYoloDeadLoopHandler/
├── configurations/          # 各种AI工具的配置
│   ├── claude-code/        # Claude Code配置
│   ├── opencode/           # OpenCode配置（待补充）
│   └── codex/              # Codex配置（待补充）
├── examples/               # 使用示例
├── README.md               # 项目说明
├── LICENSE                 # MIT许可证
└── CONTRIBUTING.md         # 贡献指南
```

### 代码风格

- 使用 4 空格缩进
- JSON 文件需要格式化
- Markdown 文档遵循现有风格
- 注释清晰明了

### 配置文件规范

#### JSON 格式
- 必须是有效的 JSON
- 使用 2 空格缩进
- 按字母顺序排列键值
- 添加必要的注释

#### 配置验证
```bash
# 验证 JSON 格式
jq < configurations/claude-code/complete-config.json

# 检查必需字段
jq '.approvalMode and .permissions' configurations/claude-code/complete-config.json
```

### 文档规范

#### README 文档
- 清晰的标题层级
- 代码示例可执行
- 添加使用场景
- 包含故障排除

#### 配置文档
- 详细的参数说明
- 实际使用示例
- 最佳实践建议
- 安全注意事项

## 🎯 贡献类型

### 📝 文档改进
- 修正错别字和语法
- 添加更多示例
- 改进说明清晰度
- 翻译文档

### 🐛 Bug 修复
- 修复配置错误
- 解决兼容性问题
- 优化性能问题
- 增强错误处理

### ✨ 新功能
- 添加新的AI工具配置
- 实现新的检测模式
- 开发配置验证工具
- 创建管理界面

### 🎨 用户体验
- 简化配置流程
- 改进错误提示
- 优化文档结构
- 增强可读性

### 🧪 测试
- 添加测试用例
- 提高测试覆盖率
- 验证配置正确性
- 性能基准测试

## 🔍 待办事项

### 高优先级
- [ ] 添加 OpenCode 配置文档
- [ ] 添加 Codex 配置文档
- [ ] 实现配置验证工具
- [ ] 创建在线配置生成器

### 中优先级
- [ ] 支持更多 AI 工具
- [ ] 添加图形化配置界面
- [ ] 实现配置模板系统
- [ ] 开发 VS Code 扩展

### 低优先级
- [ ] 多语言文档
- [ ] 视频教程
- [ ] 配置分享社区
- [ ] 性能监控面板

## 🤝 参与方式

### 新手友好
即使你是新手，也可以通过以下方式贡献：

- 📖 改进文档拼写和语法
- 🐛 报告 bug 和问题
- 💬 参与讨论提供建议
- 🌟 帮助推广项目

### 技术贡献
如果你有技术背景：

- 🔧 修复已知的 bug
- ✨ 实现新功能
- 🧪 添加测试覆盖
- 📝 完善技术文档

### 社区建设
帮助建设更好的社区：

- 💬 回答其他用户问题
- 📢 分享使用经验
- 🎯 组织技术分享
- 📚 创建学习资源

## 📧 联系方式

- GitHub Issues: [项目问题](https://github.com/yourusername/agentYoloDeadLoopHandler/issues)
- GitHub Discussions: [技术讨论](https://github.com/yourusername/agentYoloDeadLoopHandler/discussions)
- Email: your.email@example.com

## 🏆 贡献者认可

所有贡献者都会在项目的 [CONTRIBUTORS.md](CONTRIBUTORS.md) 文件中被列出。

## 📄 许可证

通过贡献代码，你同意你的贡献将在 [MIT License](LICENSE) 下发布。

---

## 🎉 特别感谢

感谢每一位贡献者，你们的让 AI 开发社区更加美好！

**一起让AI开发更高效、更安全！** 🚀🛡️