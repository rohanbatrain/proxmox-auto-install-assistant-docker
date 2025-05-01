# proxmox-auto-install-assistant-docker

The official Proxmox Automated Installer is only available for Debian-based systems — but what about Arch and other distros? This project packages the installer in a Docker container, making it usable on Arch Linux and other non-Debian distributions.  I needed this for my own Arch setup — so I built it. Now you can, too.


--

 docker run --rm \
  -v /home/rohan/Documents/Scripts/iso:/iso:ro \
  -v /home/rohan/Documents/Scripts/secrets/pve-1:/answers:ro \
  -v /home/rohan/Documents/Scripts/iso/output:/out \
  proxmox-auto-installer:latest \
    /iso/proxmox-ve_8.4-1.iso \
    --fetch-from iso \
    --answer-file /answers/answer.toml \
    --output /out/proxmox-ve_8.4-auto.iso