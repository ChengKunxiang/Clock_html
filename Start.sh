#!/bin/bash

# 获取当前脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 定义HTML文件路径（与脚本同目录）
HTML_FILE="$SCRIPT_DIR/index.html"  # 替换为你的实际HTML文件名

# 定义浏览器启动参数
BROWSERS=(
    "epiphany --fullscreen"          # 最适合信息亭模式
    "firefox --kiosk"                # Firefox全屏模式
    "google-chrome --start-fullscreen"  # Chrome全屏
    "chromium-browser --start-fullscreen"  # Chromium全屏
)

# 检测可用浏览器
find_browser() {
    for browser in "${BROWSERS[@]}"; do
        command=$(echo "$browser" | awk '{print $1}')
        if command -v "$command" &>/dev/null; then
            echo "$browser"  # 返回找到的浏览器命令
            return 0
        fi
    done
    return 1
}

# 检测并启动浏览器的逻辑
selected_browser=$(find_browser)
if [ $? -ne 0 ]; then
    echo "错误：未找到支持的浏览器，请安装以下任意浏览器："
    for browser in "${BROWSERS[@]}"; do
        echo "  - $(echo "$browser" | awk '{print $1}')"
    done
    exit 1
fi

# 设置DISPLAY环境变量（适用于没有GUI加载的情况） 
export DISPLAY=${DISPLAY:-:0}

# 启动浏览器前清空可能存在的锁文件（针对Firefox）
find ~/.mozilla -name "*lock" -delete 2>/dev/null

# 启动浏览器
echo "正在使用 ${selected_browser%% *} 启动..."
$selected_browser "$HTML_FILE" &

# 窗口管理优化（对于某些需要额外处理的浏览器）
sleep 3  # 等待浏览器初始化

# 使用wmctrl强制窗口全屏（双重保险）
if command -v wmctrl &>/dev/null; then
    wmctrl -r "your_page.html" -b toggle,fullscreen  # 将"your_page.html"改为页面标题关键词
fi

# 禁用屏幕保护（可选）
# xset s off
# xset -dpms
# xset s noblank
