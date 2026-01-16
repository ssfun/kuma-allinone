FROM ghcr.io/open-webui/open-webui:main-slim

# Choreo 用户 ID
ARG CHOREO_UID=10014
ARG CHOREO_GID=10014

# --- 1. 核心路径重定向 (全部指向 /tmp) ---
# 必须覆盖原镜像中写死的 /app/backend/data 路径，否则会因只读权限报错
ENV DATA_DIR=/tmp/data
ENV HOME=/tmp

# 覆盖 HuggingFace、SentenceTransformer 等模型的缓存路径
ENV HF_HOME=/tmp/data/cache/embedding/models
ENV SENTENCE_TRANSFORMERS_HOME=/tmp/data/cache/embedding/models
ENV TIKTOKEN_CACHE_DIR=/tmp/data/cache/tiktoken
ENV WHISPER_MODEL_DIR=/tmp/data/cache/whisper/models

# --- 2. 切换用户 ---
USER 10014

# --- 3. 关键修复：运行时创建目录 ---
# 我们修改 CMD，在启动应用前，先执行 mkdir -p /tmp/data
# 这样能保证 SQLite 写入时目录一定存在
CMD ["bash", "-c", "mkdir -p /tmp/data && exec bash start.sh"]
