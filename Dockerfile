# syntax=docker/dockerfile:1
FROM debian:bookworm-slim

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      gnupg \
      lsb-release \
      wget \
      xorriso \
 && update-ca-certificates \
 \
 # Add the no-subscription repo as trusted (HTTP)
 && echo "deb [trusted=yes arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" \
      > /etc/apt/sources.list.d/pve-no-subscription.list \
 \
 # Fetch and install the Proxmox VE Bookworm GPG key
 && wget -qO /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg \
      https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg \
 \
 # Install the auto-install assistant
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      proxmox-auto-install-assistant \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
ENTRYPOINT ["proxmox-auto-install-assistant", "prepare-iso"]
