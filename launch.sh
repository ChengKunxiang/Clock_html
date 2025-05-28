#!/bin/bash

# 配置参数
HTML_FILE="index.html"      # 修改为你的HTML文件名
PORT=8080                   # HTTP服务端口
FIREFOX_PATH="/usr/bin/firefox"  # Firefox路径（确认实际路径）

# 获取当前脚本所在目录
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 检查依赖项
check_dependencies() {
    if ! [ -f "$FIREFOX_PATH" ]; then
        echo "错误：Firefox未安装或路径不正确，请确认安装Firefox"
        exit 1
    fi
    
    if ! command -v python3 &>/dev/null; then
        echo "错误：需要Python3运行本地服务器"
        exit 1
    fi
}

# 启动本地服务器
start_server() {
    echo "在 $PORT 端口启动Web服务器..."
    python3 -m http.server "$PORT" --directory "$BASE_DIR" >/dev/null 2>&1 &
    SERVER_PID=$!
    sleep 1  # 等待服务器初始化
}

# 清理函数
cleanup() {
    kill "$SERVER_PID" 2>/dev/null
    exit 0
}

# 主流程
check_dependencies
start_server

# 注册退出处理
trap cleanup EXIT INT TERM

# 使用Firefox启动页面
echo "使用Firefox全屏启动..."
"$FIREFOX_PATH" --kiosk "http://localhost:$PORT/$HTML_FILE" &

# 保持前台运行（需保持此循环）
echo "按 Ctrl+C 退出程序..."
while true; do sleep 3600; done
