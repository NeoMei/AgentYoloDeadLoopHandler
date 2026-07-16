#!/bin/bash

# Claude Code YOLO 模式一键设置脚本
# 来源: https://github.com/NeoMei/AgentYoloDeadLoopHandler

set -e

VERSION="1.0.0"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置内容
YOLO_CONFIG='{
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
}'

# 打印带颜色的信息
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 显示帮助信息
show_help() {
    cat << EOF
Claude Code YOLO 模式一键设置脚本

用法: $0 [选项]

选项:
    -g, --global      安装到全局配置 (~/.claude/settings.json)
    -p, --project     安装到项目配置 (.claude/settings.json)
    -u, --uninstall    卸载 YOLO 模式
    -b, --backup      备份现有配置
    -h, --help        显示此帮助信息

示例:
    $0 --global       # 全局安装 YOLO 模式
    $0 --project      # 项目安装 YOLO 模式
    $0 --uninstall     # 卸载 YOLO 模式

来源: https://github.com/NeoMei/AgentYoloDeadLoopHandler
EOF
}

# 备份现有配置
backup_config() {
    local config_file=$1
    local backup_dir="$HOME/.claude-backups"

    if [ -f "$config_file" ]; then
        mkdir -p "$backup_dir"
        local timestamp=$(date +%Y%m%d_%H%M%S)
        local backup_file="$backup_dir/settings_backup_$timestamp.json"

        cp "$config_file" "$backup_file"
        print_success "配置已备份到: $backup_file"
    fi
}

# 安装YOLO模式
install_yolo_mode() {
    local config_file=$1
    local config_type=$2

    print_info "准备安装 $config_type YOLO 模式..."

    # 检查配置文件是否存在
    if [ -f "$config_file" ]; then
        print_warning "发现现有配置文件"
        read -p "是否备份现有配置？(y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            backup_config "$config_file"
        fi
    fi

    # 创建配置目录（如果不存在）
    local config_dir=$(dirname "$config_file")
    mkdir -p "$config_dir"

    # 写入YOLO配置
    echo "$YOLO_CONFIG" > "$config_file"

    print_success "$config_type YOLO 模式安装完成！"
    print_info "配置文件: $config_file"
    print_info "请重启 Claude Code 以使配置生效"
}

# 卸载YOLO模式
uninstall_yolo_mode() {
    local config_file=$1
    local config_type=$2

    print_info "准备卸载 $config_type YOLO 模式..."

    if [ ! -f "$config_file" ]; then
        print_warning "$config_type 配置文件不存在"
        return
    fi

    # 备份现有配置
    backup_config "$config_file"

    # 删除配置文件
    rm "$config_file"

    print_success "$config_type YOLO 模式已卸载"
    print_info "配置文件: $config_file"
    print_info "备份保存在: ~/.claude-backups/"
}

# 验证YOLO模式是否已安装
verify_yolo_mode() {
    local config_file=$1
    local config_type=$2

    if [ ! -f "$config_file" ]; then
        print_warning "$config_type YOLO 模式未安装"
        return 1
    fi

    # 检查是否包含YOLO配置
    if grep -q '"defaultMode": "auto"' "$config_file" && \
       grep -q '"Bash"' "$config_file"; then
        print_success "$config_type YOLO 模式已安装并激活"
        return 0
    else
        print_warning "$config_type 配置文件存在但可能不是YOLO模式"
        return 1
    fi
}

# 主函数
main() {
    echo -e "${BLUE}Claude Code YOLO Mode Setup Script v${VERSION}${NC}"
    echo ""

    local action="install"
    local scope="global"

    # 解析命令行参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -g|--global)
                scope="global"
                shift
                ;;
            -p|--project)
                scope="project"
                shift
                ;;
            -u|--uninstall)
                action="uninstall"
                shift
                ;;
            -b|--backup)
                backup_config "$HOME/.claude/settings.json"
                if [ -f ".claude/settings.json" ]; then
                    backup_config ".claude/settings.json"
                fi
                exit 0
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                print_error "未知选项: $1"
                show_help
                exit 1
                ;;
        esac
    done

    # 根据范围和操作执行相应功能
    case $scope in
        global)
            local config_file="$HOME/.claude/settings.json"
            local config_type="全局"
            ;;
        project)
            local config_file=".claude/settings.json"
            local config_type="项目"
            ;;
    esac

    case $action in
        install)
            install_yolo_mode "$config_file" "$config_type"
            verify_yolo_mode "$config_file" "$config_type"
            ;;
        uninstall)
            uninstall_yolo_mode "$config_file" "$config_type"
            ;;
    esac

    print_success "操作完成！YOLO Mode v${VERSION} 已配置"
}

# 执行主函数
main "$@"