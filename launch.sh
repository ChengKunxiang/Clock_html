#!/bin/bash

# 启动 HTTP 服务器并在后台运行
python -m http.server 8000 &
SERVER_PID=$!

# 等待服务器启动
echo "等待服务器启动..."
sleep 2

# 打开 Firefox 并全屏显示指定的 URL
URL="http://localhost:8000"
firefox -fullscreen "$URL" &

# 捕获 Ctrl+C 信号以停止服务器
trap "kill $SERVER_PID && echo '服务器已停止。' && exit" INT

# 等待用户关闭浏览器或按 Ctrl+C
wait $SERVER_PID