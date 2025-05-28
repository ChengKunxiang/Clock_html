#!/bin/bash

# 设置文件和目录路径
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HTML_FILE="$BASE_DIR/index.html"    # 修改为你的HTML文件名
PORT=8000                          # HTTP服务端口

# 检查必要的依赖
check_dependencies() {
    # 检查Python3
    if ! command -v python3 &>/dev/null; then
        echo "错误：需要Python3来运行本地Web服务器"
        exit 1
    fi
    
    # 检查浏览器
    if ! command -v firefox && ! command -v google-chrome && ! command -v chromium-browser; then
        echo "错误：请安装 Firefox、Chrome 或 Chromium 浏览器"
        exit 1
    fi
}

# 启动本地Web服务器
start_server() {
    echo "在端口 $PORT 启动本地Web服务器..."
    python3 -m http.server "$PORT" --directory "$BASE_DIR" >/dev/null 2>&1 &
    SERVER_PID=$!
    sleep 2  # 等待服务器初始化
}

# 关闭服务器的清理函数
cleanup() {
    kill "$SERVER_PID" 2>/dev/null
    exit 0
}

# 主执行流程
check_dependencies
start_server

# 捕获退出信号
trap cleanup EXIT

# 自动选择浏览器（优先级：Chrome > Firefox > Chromium）
if command -v google-chrome &>/dev/null; then
    firefox --kiosk "http://localhost:$PORT" &> /dev/null
elif command -v firefox &>/dev/null; then
    google-chrome --start-fullscreen "http://localhost:$PORT" &> /dev/null
else
    chromium-browser --start-fullscreen "http://localhost:$PORT" &> /dev/null
fi

# 保持脚本运行
echo "按 Ctrl+C 退出..."
while true; do sleep 1; done
