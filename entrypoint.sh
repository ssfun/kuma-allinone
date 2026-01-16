#!/bin/sh

# ==============================
# 环境变量配置与默认值
# ==============================
# Agent 自动注册所需的变量
KOMARI_SERVER="${KOMARI_SERVER:-}"
KOMARI_SECRET="${KOMARI_SECRET:-}"

# sing-box 所需的变量
SB_PORT=${SB_PORT:-""}
SB_PASSWD=${SB_PASSWD:-""}

# cloudflared 所需的变量
CF_TOKEN=${CF_TOKEN:-""}

# ==============================
# 1. 启动 komari-agent
# ==============================
if [ -n "$KOMARI_SERVER" ] && [ -n "$KOMARI_SECRET" ]; then
    echo "[Komari] 启动监控..."
    /app/komari-agent -e "$KOMARI_SERVER" -t "$KOMARI_SECRET" --disable-auto-update >/dev/null 2>&1 &
else
    echo "[Komari] 未配置，跳过。"
fi

# ==============================
# 2. 配置并启动 sing-box (已整合配置生成逻辑)
# ==============================
if [ -n "$SB_PORT" ]; then
    echo "Configuring and Starting sing-box..."
    
    # 检查必要参数
    if [ -z "$SB_PASSWD" ]; then
        echo "Warning: SB_PASSWD not set, sing-box might fail to authenticate users."
    fi

    # 生成配置文件 /app/sing-box.json
    cat <<EOF > /app/sing-box.json
{
  "log": {
    "disabled": false,
    "level": "info",
    "timestamp": true
  },
  "inbounds": [
    {
      "type": "trojan",
      "tag": "trojan-in",
      "listen": "127.0.0.1",
      "listen_port": ${SB_PORT},
      "sniff": true,
      "sniff_override_destination": false,
      "users": [
        {
          "name": "trojan",
          "password": "${SB_PASSWD}"
        }
      ],
      "transport": {
        "type": "ws",
        "path": "/media-cdn",
        "max_early_data": 2048,
        "early_data_header_name": "Sec-WebSocket-Protocol"
      }
    }
  ],
  "outbounds": [
    {
      "type": "direct",
      "tag": "direct"
    }
  ],
  "route": {
    "rules": [],
    "rule_set": [],
    "final": "direct",
    "auto_detect_interface": true
  },
  "experimental": {
    "cache_file": {
      "enabled": true
    }
  }
}
EOF
    echo "Sing-box config generated at /app/sing-box.json"

    # 启动 sing-box
    sing-box run -c /app/sing-box.json >/dev/null 2>&1 &
else
    echo "Warning: SB_PORT is not set, skipping sing-box setup"
fi

# ==============================
# 3. 启动 cloudflared
# ==============================
if [ -n "$CF_TOKEN" ]; then
    echo "Starting cloudflared..."
    cloudflared tunnel --no-autoupdate --protocol http2 --edge-ip-version 4 run --token "$TUNNEL_TOKEN" &
else
    echo "Warning: CF_TOKEN is not set, skipping cloudflared"
fi

# ==============================
# 4. 启动主应用
# ==============================
echo "[Kuma] 启动监控..."
# 使用 exec 确保 Node 处理 OS 信号
exec node server/server.js
