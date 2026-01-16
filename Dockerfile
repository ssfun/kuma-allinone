# 1. 继续使用 main 镜像 (包含预置模型)
FROM ghcr.io/open-webui/open-webui:main-slim

# 2. 将 Open WebUI 的所有动态数据路径指向 /tmp
# DATA_DIR 决定了 webui.db (数据库) 和 uploads (上传文件) 的位置
ENV DATA_DIR=/tmp/data

# 同时修改 HOME 目录，防止某些 Python 工具试图写入 /root/.cache
ENV HOME=/tmp

# 3. 切换到 Choreo 要求的非 root 用户
USER 10014

