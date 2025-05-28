#!/bin/bash

# 指定 HTML 文件的路径
HTML_FILE="index.html"
HTML_DIR=$(dirname "$HTML_FILE")
CSS_FILE="$HTML_DIR/index.css"

# 检查 HTML 文件是否存在
if [ ! -f "$HTML_FILE" ]; then
    echo "HTML 文件不存在: $HTML_FILE"
    exit 1
fi

# 检查 CSS 文件是否存在
if [ ! -f "$CSS_FILE" ]; then
    echo "CSS 文件不存在: $CSS_FILE"
    exit 1
fi

# 使用 Python 的 SimpleHTTPServer 模块启动一个本地服务器
echo "启动本地服务器..."
cd "$HTML_DIR"
python3 -m http.server 8000 &
SERVER_PID=$!

# 打开浏览器访问本地服务器上的 HTML 文件并全屏
echo "在浏览器中打开 HTML 文件..."
# 使用 Chrome 浏览器并全屏

firefox -fullscreen "http://localhost:8000/$(basename "$HTML_FILE")"

# 等待用户关闭浏览器
echo "按 Enter 键停止服务器..."
read

# 停止本地服务器
kill $SERVER_PID
echo "服务器已停止。"