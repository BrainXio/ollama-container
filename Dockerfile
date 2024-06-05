# Stage 1: Builder stage
FROM nvidia/cuda:12.4.1-base-ubuntu22.04 as builder

ARG OLLAMA_VERSION=v0.1.34

ENV APP_AGENTS=/mnt/c/agents \
    APP_DATA=/mnt/c/data \
    APP_LOGGING=/var/logs \
    APP_SRC=/mnt/c/src \
    APP_MSG_BUS=/mnt/c/bus \
    OLLAMA_MODELS=/mnt/c/models \
    OLLAMA_HOST=0.0.0.0

# Install necessary packages and clean up in one step to minimize layers
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    apt-get -y autoremove

# Download Ollama binary with versioning
RUN curl -L https://github.com/ollama/ollama/releases/download/${OLLAMA_VERSION}/ollama-linux-amd64 -o /usr/bin/ollama && \
    chmod +x /usr/bin/ollama

# Create a wrapper script to set custom name
RUN echo "#!/bin/bash\nexec -a custom-ollama /usr/bin/ollama serve" > /usr/local/bin/start-ollama.sh && \
    chmod +x /usr/local/bin/start-ollama.sh

# Create necessary directories and user in one step
RUN mkdir -p ${OLLAMA_MODELS} ${APP_AGENTS} ${APP_DATA} ${APP_LOGGING} ${APP_SRC} ${APP_MSG_BUS} && \
    useradd -r -s /bin/false -m -d /usr/share/ollama ollama

# Stage 2: Final image
FROM nvidia/cuda:12.4.1-base-ubuntu22.04

ARG USERNAME=ollama

ENV APP_AGENTS=/mnt/c/agents \
    APP_DATA=/mnt/c/data \
    APP_LOGGING=/var/logs \
    APP_SRC=/mnt/c/src \
    APP_MSG_BUS=/mnt/c/bus \
    OLLAMA_MODELS=/mnt/c/models \
    OLLAMA_HOST=0.0.0.0

# Install tini and clean up in one step
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    tini && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    apt-get -y autoremove

# Copy necessary files from builder
COPY --from=builder /usr/bin/ollama /usr/bin/ollama
COPY --from=builder /usr/local/bin/start-ollama.sh /usr/local/bin/start-ollama.sh
# Only copy necessary directories
COPY --from=builder /mnt/c/ /mnt/c/
COPY --from=builder /usr/share/ollama /usr/share/ollama

# Create necessary directories and set permissions in one step
RUN mkdir -p ${OLLAMA_MODELS} ${APP_AGENTS} ${APP_DATA} ${APP_LOGGING} ${APP_SRC} ${APP_MSG_BUS} && \
    useradd -r -s /bin/false -m -d /usr/share/${USERNAME} ${USERNAME} && \
    chown -R ${USERNAME}:${USERNAME} ${OLLAMA_MODELS} ${APP_AGENTS} ${APP_DATA} ${APP_LOGGING} ${APP_SRC} ${APP_MSG_BUS}

# Set the working directory
WORKDIR ${APP_AGENTS}

# Use tini as the entry point
ENTRYPOINT ["/usr/bin/tini", "--"]

# Command to start Ollama service and keep it running
CMD ["/bin/bash", "-c", "/usr/local/bin/start-ollama.sh & sleep infinity"]

# Expose necessary ports
EXPOSE 11434
