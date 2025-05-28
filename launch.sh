#!/bin/bash

# 获取脚本所在绝对路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HTML_FILE="$SCRIPT_DIR/index.html"  # 修改为你的HTML文件名

# 检查HTML文件是否存在
if [ ! -f "$HTML_FILE" ]; then
    echo "错误：未找到HTML文件 $HTML_FILE"
    exit 1
fi

# 检测浏览器启动参数
declare -A BROWSER_COMMANDS=(
    ["epiphany"]="epiphany --fullscreen"                   # 最适合信息亭
    ["firefox"]="firefox --kiosk"                          # Firefox全屏
    ["google-chrome"]="google-chrome --start-fullscreen"   # Chrome全屏
    ["chromium-browser"]="chromium-browser --start-fullscreen" # Chromium
)

# 自动检测可用浏览器
for browser in epiphany firefox google-chrome chromium-browser; do
    if command -v "$browser" &>/dev/null; then
        selected_browser="${BROWSER_COMMANDS[$browser]}"
        break
    fi
done

# 浏览器检测失败提醒
if [ -z "$selected_browser" ]; then
    echo "错误：请安装以下任一浏览器："
    printf '- %s\n' "${BROWSER_COMMANDS[@]}"
    exit 1
fi

# 启动浏览器（自动处理本地文件协议）
export DISPLAY=${DISPLAY:-:0}
nohup $selected_browser "file://$HTML_FILE" >/dev/null 2>&1 &

# 窗口全屏二次确认
sleep 3  # 等待浏览器初始化
if command -v wmctrl &>/dev/null; then
    wmctrl -r "$(basename "$HTML_FILE")" -b toggle,fullscreen
fi

echo "已使用 ${selected_browser%% *} 全屏启动"
