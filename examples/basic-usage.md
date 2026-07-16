# 基础使用示例

## 🚀 快速开始

### 1. Claude Code 基础配置

#### 步骤 1：创建配置目录
```bash
cd /path/to/your/project
mkdir -p .claude
```

#### 步骤 2：复制配置文件
```bash
# 从本项目中复制完整配置
cp path/to/agentYoloDeadLoopHandler/configurations/claude-code/complete-config.json .claude/settings.json
```

#### 步骤 3：验证配置
```bash
# 检查配置文件是否存在
cat .claude/settings.json
```

### 2. 立即体验 YOLO 模式

配置完成后，你可以立即享受：

#### ✅ 无阻碍的文件操作
```bash
# 这些操作都会立即执行，无需确认
touch test.txt
echo "Hello YOLO!" > test.txt
cat test.txt
```

#### ✅ 自动化的命令执行
```bash
# 命令也会立即执行
npm install
git status
ls -la
```

#### ✅ 智能的循环保护
```bash
# 系统会在后台监控，防止意外循环
for i in {1..10}; do
  echo "Loop $i"
  # 如果检测到异常重复模式，会自动介入
done
```

## 📖 典型使用场景

### 场景 1：前端开发工作流

```bash
# 安装依赖 - 立即执行
npm install

# 启动开发服务器 - 无需确认
npm run dev

# 编辑配置文件 - 自动完成
echo "VITE_API_URL=http://localhost:3000" > .env

# Git 操作 - 顺畅执行
git add .
git commit -m "Update config"
```

### 场景 2：后端 API 开发

```bash
# 创建新的 API 路由
mkdir -p src/routes/users

# 生成控制器文件
echo "// User controller" > src/routes/users/controller.js

# 安装新依赖
npm install express-validator

# 重启服务器
npm run start
```

### 场景 3：数据库迁移

```bash
# 创建迁移文件
npx prisma migrate dev --name init

# 生成 Prisma 客户端
npx prisma generate

# 启动数据库服务
docker-compose up -d

# 执行种子数据
npm run seed
```

## 🛡️ 循环防护实际效果

### 正常循环 ✅
```javascript
// 这个循环会正常执行
for (let i = 0; i < 5; i++) {
  console.log(`Processing item ${i}`);
  // ✅ 正常的循环逻辑，不会触发防护
}
```

### 异常重复 ⚠️
```bash
# 如果在脚本或交互中意外执行：
rm -rf node_modules  # 第1次 - OK
rm -rf node_modules  # 第2次 - OK  
rm -rf node_modules  # 第3次 - OK
rm -rf node_modules  # 第4次 - 🛡️ 被拦截
# 系统检测到危险操作的异常重复
```

## 🔧 配置调试

### 查看当前配置
```bash
# 查看项目配置
cat .claude/settings.json | jq

# 查看全局配置
cat ~/.claude/settings.json | jq
```

### 测试循环防护
```bash
# 创建测试脚本
cat > test-loop.sh << 'EOF'
#!/bin/bash
for i in {1..5}; do
  echo "Loop iteration $i"
  date >> test.log
done
EOF

chmod +x test-loop.sh
./test-loop.sh
# 正常循环会完整执行
```

### 临时禁用防护
```bash
# 编辑配置文件
nano .claude/settings.json

# 临时禁用循环防护
{
  "loopPrevention": {
    "enabled": false
  }
}
```

## 💡 使用技巧

### 1. 分层配置
```bash
# 全局配置：基础 YOLO 模式
~/.claude/settings.json

# 项目配置：特定项目设置
/project/.claude/settings.json
```

### 2. 环境特定配置
```bash
# 开发环境：完全 YOLO + 防护
cp configurations/claude-code/complete-config.json .claude/settings.json

# 生产环境：更保守的设置
# 手动调整配置参数
```

### 3. 团队协作
```bash
# 提交配置到项目仓库
git add .claude/settings.json
git commit -m "Add YOLO mode config"

# 团队成员统一配置
git pull
```

## 🐛 常见问题

### Q: 配置不生效？
```bash
# 检查文件位置
ls -la .claude/settings.json

# 验证 JSON 格式
cat .claude/settings.json | jq .

# 重启 Claude Code
# 配置会在重启后完全生效
```

### Q: 循环防护太敏感？
```json
// 调整防护参数
{
  "loopPrevention": {
    "maxSameOperationCalls": 10,  // 增加阈值
    "detectionWindow": 120        // 延长检测窗口
  }
}
```

### Q: 需要特定操作确认？
```json
// 移除特定的自动批准
{
  "autoApprove": [
    "Read",
    "Write",
    "Edit"
    // 移除 "Bash" - 需要确认命令执行
  ],
  "bashBehavior": "ask"
}
```

## 🚀 下一步

- 查看 [高级场景](advanced-scenarios.md)
- 了解特定工具的配置
- 参与社区贡献

---

**开始享受高效的 AI 开发体验吧！** 🎉