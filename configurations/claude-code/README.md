# Claude Code 配置

## 🚀 YOLO 模式 + 死循环防护

这个配置为 Claude Code 提供了完美的平衡：既有 YOLO 模式的速度，又有智能的循环防护。

## 📋 配置文件说明

### `yolo-mode.json`
纯 YOLO 模式配置，启用所有自动化权限。

### `loop-prevention.json`
死循环防护配置，检测和阻止重复操作。

### `complete-config.json`
完整配置文件，包含 YOLO 模式和循环防护。

## 🔧 使用方法

### 1. 复制完整配置

```bash
# 复制完整配置到你的项目
cp configurations/claude-code/complete-config.json /path/to/your/project/.claude/settings.json
```

### 2. 仅启用 YOLO 模式

```bash
# 复制 YOLO 模式配置
cp configurations/claude-code/yolo-mode.json /path/to/your/project/.claude/settings.json
```

### 3. 仅添加循环防护

如果你的项目已有配置，可以合并循环防护设置。

## ⚙️ 配置选项

### 基础权限

```json
{
  "approvalMode": "auto",
  "permissions": {
    "allowRead": true,    // 允许文件读取
    "allowWrite": true,   // 允许文件写入  
    "allowBash": true,    // 允许命令执行
    "allowEdit": true,    // 允许文件编辑
    "allowNetwork": true, // 允许网络请求
    "allowMCP": true,     // 允许 MCP 调用
    "allowAgent": true    // 允许子代理
  }
}
```

### 自动批准操作

```json
{
  "autoApprove": [
    "Read",           // 文件读取
    "Write",          // 文件写入
    "Edit",           // 文件编辑
    "Bash",           // 命令执行
    "LSP",            // 代码智能
    "TaskCreate",     // 任务创建
    "TaskUpdate",     // 任务更新
    "Skill"           // 技能调用
  ]
}
```

### 循环防护参数

```json
{
  "loopPrevention": {
    "enabled": true,              // 启用循环防护
    "detectionWindow": 60,        // 检测窗口（秒）
    "maxSameOperationCalls": 3,   // 相同操作最大次数
    "maxSimilarCalls": 5,         // 相似操作最大次数
    "cooldownPeriod": 10,         // 冷却期（秒）
    "blockOnPattern": [           // 拦截模式
      "same.*operation.*3.*times",
      "similar.*call.*5.*times"
    ]
  }
}
```

## 🎯 工作原理

### YOLO 模式
所有配置的操作都会立即执行，无需手动确认：
- ✅ 文件操作（读、写、编辑）
- ✅ 命令执行
- ✅ 网络请求
- ✅ 任务管理
- ✅ 技能调用

### 智能循环防护
系统会监控操作模式，在检测到潜在循环时介入：

**正常操作：**
```bash
echo "test" > file.txt  # 立即执行 ✅
git status              # 立即执行 ✅
npm install             # 立即执行 ✅
```

**触发防护：**
```bash
# 60秒内相同操作超过3次
echo "test" > file.txt  # 第1次 - OK ✅
echo "test" > file.txt  # 第2次 - OK ✅  
echo "test" > file.txt  # 第3次 - OK ✅
echo "test" > file.txt  # 第4次 - 被拦截 🛡️
```

## 🔍 高级配置

### 自定义检测参数

```json
{
  "loopPrevention": {
    "detectionWindow": 120,        // 增加检测窗口到2分钟
    "maxSameOperationCalls": 5,   // 允许更多重复
    "cooldownPeriod": 30           // 更长的冷却期
  }
}
```

### 添加危险操作拦截

```json
{
  "restrictedOperations": [
    "rm -rf",     "dd ",         "mkfs",
    "chmod -R",   "chown -R"
  ],
  "safetyChecks": {
    "preventDataLoss": true,
    "confirmDestructive": true
  }
}
```

## 🛡️ 安全建议

1. **仅在可信环境使用** - YOLO 模式会自动执行操作
2. **版本控制重要** - 确保项目在 Git 控制下
3. **定期检查配置** - 根据需要调整参数
4. **测试新配置** - 在非关键项目上先测试

## 📊 性能考虑

循环防护对性能的影响很小：
- 检测算法：O(1) 复杂度
- 内存占用：约 1-2MB
- CPU 影响：几乎无感知

## 🐛 故障排除

### 配置不生效
1. 确认文件路径：`.claude/settings.json`
2. 检查 JSON 格式是否正确
3. 重启 Claude Code

### 循环防护过于敏感
```json
{
  "loopPrevention": {
    "maxSameOperationCalls": 10,  // 增加阈值
    "detectionWindow": 120         // 延长窗口
  }
}
```

### 需要临时禁用防护
```json
{
  "loopPrevention": {
    "enabled": false
  }
}
```

## 💡 最佳实践

1. **开发环境**：使用完整配置（YOLO + 防护）
2. **生产环境**：考虑增加确认步骤
3. **团队协作**：在项目仓库中提交配置文件
4. **敏感项目**：根据需要调整权限设置

---

**Claude Code + YOLO 模式 = 极速开发体验！** 🚀