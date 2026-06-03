FROM debian:trixie

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
    # Proxmox Trixie Release Key
    install -d /etc/apt/keyrings && \
    wget https://enterprise.proxmox.com/debian/proxmox-release-trixie.gpg \
        -O /etc/apt/keyrings/proxmox-release-trixie.gpg && \
    printf 'Types: deb\nURIs: http://download.proxmox.com/debian/pve\nSuites: trixie\nComponents: pve-no-subscription\nSigned-By: /etc/apt/keyrings/proxmox-release-trixie.gpg\n' \
        > /etc/apt/sources.list.d/proxmox.sources && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        proxmox-auto-install-assistant && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]