# 高级使用场景

## 🎯 高级配置场景

### 1. 多环境配置管理

#### 开发环境配置
```json
{
  "approvalMode": "auto",
  "bashBehavior": "auto",
  "networkBehavior": "auto",
  "loopPrevention": {
    "enabled": true,
    "maxSameOperationCalls": 5
  }
}
```

#### 生产环境配置
```json
{
  "approvalMode": "normal",
  "bashBehavior": "ask",
  "networkBehavior": "ask",
  "loopPrevention": {
    "enabled": true,
    "maxSameOperationCalls": 3
  }
}
```

#### CI/CD 环境配置
```json
{
  "approvalMode": "auto",
  "bashBehavior": "auto",
  "networkBehavior": "deny",
  "loopPrevention": {
    "enabled": true,
    "maxSameOperationCalls": 2
  }
}
```

### 2. 特定项目类型配置

#### 前端项目配置
```json
{
  "approvalMode": "auto",
  "autoApprove": [
    "Read", "Write", "Edit", "Bash",
    "npm", "yarn", "pnpm"
  ],
  "loopPrevention": {
    "enabled": true,
    "detectionWindow": 30
  }
}
```

#### 后端项目配置
```json
{
  "approvalMode": "auto", 
  "autoApprove": [
    "Read", "Write", "Edit", "Bash",
    "npm", "python", "java", "go"
  ],
  "loopPrevention": {
    "enabled": true,
    "maxSameOperationCalls": 3
  }
}
```

#### DevOps 项目配置
```json
{
  "approvalMode": "ask",
  "autoApprove": ["Read", "Edit"],
  "bashBehavior": "ask",
  "loopPrevention": {
    "enabled": true,
    "maxSameOperationCalls": 2
  },
  "restrictedOperations": [
    "kubectl delete", "docker rm", 
    "terraform destroy"
  ]
}
```

### 3. 自定义循环检测模式

#### 检测特定命令重复
```json
{
  "loopPrevention": {
    "enabled": true,
    "customPatterns": [
      {
        "pattern": "npm install.*react",
        "maxCalls": 2,
        "window": 300
      },
      {
        "pattern": "git push.*force", 
        "maxCalls": 1,
        "window": 3600
      }
    ]
  }
}
```

#### 检测文件操作模式
```json
{
  "loopPrevention": {
    "enabled": true,
    "fileOperationPatterns": [
      {
        "pattern": "Write.*node_modules",
        "maxCalls": 3
      },
      {
        "pattern": "Edit.*.env",
        "maxCalls": 5
      }
    ]
  }
}
```

### 4. 性能优化配置

#### 高性能模式
```json
{
  "approvalMode": "auto",
  "performance": {
    "caching": true,
    "parallelProcessing": true,
    "asyncOperations": true
  },
  "loopPrevention": {
    "enabled": true,
    "lightweightMode": true,
    "sampling": 0.1
  }
}
```

#### 调试模式
```json
{
  "approvalMode": "auto",
  "debugging": {
    "detailedLogging": true,
    "operationTracking": true,
    "performanceMetrics": true
  },
  "loopPrevention": {
    "enabled": true,
    "verboseLogging": true
  }
}
```

### 5. 团队协作配置

#### 统一团队配置
```bash
# 在项目根目录创建团队配置文件
cat > .claude/team-settings.json << 'EOF'
{
  "approvalMode": "auto",
  "permissions": {
    "allowRead": true,
    "allowWrite": true,
    "allowBash": true
  },
  "loopPrevention": {
    "enabled": true,
    "teamStandard": true
  }
}
EOF

# 每个成员同步配置
cp .claude/team-settings.json ~/.claude/project-overrides.json
```

#### 角色特定配置
```json
// 高级开发者配置
{
  "approvalMode": "auto",
  "bashBehavior": "auto",
  "networkBehavior": "auto"
}

// 初级开发者配置  
{
  "approvalMode": "normal",
  "bashBehavior": "ask",
  "networkBehavior": "ask",
  "loopPrevention": {
    "enabled": true,
    "strictMode": true
  }
}
```

### 6. 安全强化配置

#### 金融级安全配置
```json
{
  "approvalMode": "strict",
  "bashBehavior": "deny",
  "networkBehavior": "deny",
  "permissions": {
    "allowRead": true,
    "allowWrite": false,
    "allowEdit": false,
    "allowBash": false
  },
  "loopPrevention": {
    "enabled": true,
    "paranoidMode": true
  },
  "auditing": {
    "logAllOperations": true,
    "requireApproval": true
  }
}
```

#### 企业级配置
```json
{
  "approvalMode": "normal",
  "bashBehavior": "ask",
  "networkBehavior": "ask",
  "loopPrevention": {
    "enabled": true,
    "enterpriseMode": true
  },
  "compliance": {
    "gdpr": true,
    "soc2": true,
    "hipaa": false
  }
}
```

### 7. 智能自动化场景

#### 智能依赖管理
```json
{
  "automation": {
    "dependencyManagement": {
      "autoInstall": true,
      "autoUpdate": false,
      "securityScan": true
    }
  },
  "loopPrevention": {
    "enabled": true,
    "dependencyPatterns": [
      "npm install.*--force",
      "yarn add.*--ignore-scripts"
    ]
  }
}
```

#### 智能Git操作
```json
{
  "automation": {
    "gitOperations": {
      "autoCommit": false,
      "autoPush": false,
      "smartMerge": true
    }
  },
  "loopPrevention": {
    "enabled": true,
    "gitPatterns": [
      "git reset.*--hard",
      "git clean.*-fd"
    ]
  }
}
```

### 8. 故障恢复配置

#### 灾难恢复模式
```json
{
  "approvalMode": "auto",
  "backup": {
    "autoBackup": true,
    "backupInterval": 300,
    "maxBackups": 10
  },
  "loopPrevention": {
    "enabled": true,
    "recoveryMode": true
  },
  "emergency": {
    "safeMode": true,
    "rollbackOnFailure": true
  }
}
```

#### 自愈系统
```json
{
  "selfHealing": {
    "enabled": true,
    "autoFix": true,
    "rollBack": true,
    "notifications": true
  },
  "loopPrevention": {
    "enabled": true,
    "healingPatterns": [
      "package.json修复",
      "依赖重装",
      "缓存清理"
    ]
  }
}
```

## 🔧 实用工具脚本

### 配置切换脚本
```bash
#!/bin/bash
# switch-config.sh

case "$1" in
  "dev")
    cp configs/development.json .claude/settings.json
    echo "切换到开发模式配置"
    ;;
  "prod") 
    cp configs/production.json .claude/settings.json
    echo "切换到生产模式配置"
    ;;
  "safe")
    cp configs/safe-mode.json .claude/settings.json
    echo "切换到安全模式配置"
    ;;
  *)
    echo "使用方法: $0 {dev|prod|safe}"
    ;;
esac
```

### 配置验证脚本
```bash
#!/bin/bash
# validate-config.sh

CONFIG_FILE=".claude/settings.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ 配置文件不存在"
    exit 1
fi

# 验证JSON格式
if ! jq empty "$CONFIG_FILE" 2>/dev/null; then
    echo "❌ JSON格式无效"
    exit 1
fi

echo "✅ 配置文件格式正确"

# 检查必需字段
REQUIRED_FIELDS=("approvalMode" "permissions" "autoApprove")
for field in "${REQUIRED_FIELDS[@]}"; do
    if ! jq -e ".$field" "$CONFIG_FILE" > /dev/null; then
        echo "❌ 缺少必需字段: $field"
        exit 1
    fi
done

echo "✅ 所有必需字段都存在"
echo "🎉 配置验证通过"
```

### 配置备份脚本
```bash
#!/bin/bash
# backup-config.sh

BACKUP_DIR=".claude/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p "$BACKUP_DIR"

# 备份当前配置
cp .claude/settings.json "$BACKUP_DIR/settings_$TIMESTAMP.json"
echo "✅ 配置已备份到: $BACKUP_DIR/settings_$TIMESTAMP.json"

# 清理旧备份（保留最近10个）
ls -t "$BACKUP_DIR"/settings_*.json | tail -n +11 | xargs rm -f
echo "🧹 清理了旧备份文件"
```

## 🎓 最佳实践总结

### ✅ 推荐做法

1. **分层配置**
   - 全局配置：基础设置
   - 项目配置：特定需求
   - 环境配置：开发/生产差异

2. **渐进式启用**
   - 先在非关键项目测试
   - 逐步调整参数
   - 监控效果和问题

3. **团队标准化**
   - 统一团队配置模板
   - 定期更新和优化
   - 文档化和培训

### ❌ 避免做法

1. **过度配置**
   - 不要一次性启用所有选项
   - 避免过于复杂的规则
   - 保持配置简洁明了

2. **安全忽视**
   - 敏感项目保持确认模式
   - 不要禁用所有防护
   - 定期审计配置

3. **缺乏备份**
   - 配置变更前先备份
   - 版本控制重要配置
   - 建立回滚机制

---

**掌握这些高级场景，让AI开发更上一层楼！** 🚀