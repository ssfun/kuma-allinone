# 基于轻量化的 uptime-kuma:2-slim 镜像
FROM louislam/uptime-kuma:2-slim

# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 从其他镜像复制必要的二进制文件
COPY --from=ghcr.io/sagernet/sing-box:latest /usr/local/bin/sing-box /usr/local/bin/sing-box
COPY --from=ghcr.io/komari-monitor/komari-agent:latest /app/komari-agent /app/komari-agent

# 设置工作目录
WORKDIR /app

# 复制脚本文件并设置权限
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# 创建数据目录并设置权限
RUN mkdir -p /app/data && chown -R node:node /app

# 以 node 用户运行，避免 root 权限
USER node

# 暴露端口
EXPOSE 3001

# 设置入口点脚本
CMD ["/app/entrypoint.sh"]
