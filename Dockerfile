FROM debian:bookworm

# Install required dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        gnupg \
        lsb-release \
        wget \
        curl \
        xorriso && \
    update-ca-certificates && \
    echo "deb [trusted=yes arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" \
        > /etc/apt/sources.list.d/pve-no-subscription.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        proxmox-auto-install-assistant && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
