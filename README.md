# Proxmox Auto Installer

Generate custom unattended Proxmox VE installation ISOs using Docker and profile-based configurations.

This tool wraps the official [`proxmox-auto-install-assistant`](https://github.com/proxmox/proxmox-auto-install-assistant) in a Docker image, allowing you to build automated installer ISOs using separate `answer.toml` files per profile.

---

## 📦 Features

- ✅ Supports multiple profile configurations (e.g. `pve-1`, `pve-2`)
- ✅ Uses Docker for reproducible, isolated builds
- ✅ Output ISOs labeled with profile names
- ✅ Clean and scriptable interface
- ✅ Works with any Proxmox VE ISO

---

## 🧱 Directory Structure

```
.
├── Dockerfile                  # Docker build file
├── entrypoint.sh              # Smart profile-aware entrypoint
├── iso/
│   ├── proxmox-ve_8.4-1.iso   # Input ISO
│   └── output/                # Output directory
├── secrets/
│   ├── pve-1/
│   │   └── answer.toml
│   └── pve-2/
│       └── answer.toml
```

---

## 🚀 Build the Docker Image

Run this in the directory where the `Dockerfile` is located:

```bash
docker build -t proxmox-auto-installer .
```

Ensure `entrypoint.sh` is executable:

```bash
chmod +x entrypoint.sh
```

---

## 🛠 Usage

### Single Profile

```bash
docker run --rm \
  -v $PWD/iso:/iso:ro \
  -v $PWD/secrets:/answers:ro \
  -v $PWD/iso/output:/out \
  proxmox-auto-installer:latest \
    /iso/proxmox-ve_8.4-1.iso \
    pve-1
```

### Multiple Profiles

Loop through profiles:

```bash
for profile in pve-1 pve-2; do
  docker run --rm \
    -v $PWD/iso:/iso:ro \
    -v $PWD/secrets:/answers:ro \
    -v $PWD/iso/output:/out \
    proxmox-auto-installer:latest \
    /iso/proxmox-ve_8.4-1.iso \
    $profile
done
```

---

## 📁 Output

Output ISOs will be generated in `iso/output/`:

```
iso/output/proxmox-ve_8.4-1-auto-pve-1.iso
iso/output/proxmox-ve_8.4-1-auto-pve-2.iso
```

---

## 🧪 Troubleshooting

- Ensure the `answer.toml` file exists in `secrets/<profile>/`
- Make sure Docker has permission to access the mounted volumes
- Run interactively if you want to debug:

```bash
docker run -it --entrypoint /bin/sh proxmox-auto-installer
```

---

## 🧹 Cleanup

```bash
docker rmi proxmox-auto-installer
rm iso/output/*
```

---

## 📖 Resources

- [Proxmox Auto Install Assistant GitHub](https://github.com/proxmox/proxmox-auto-install-assistant)
- [Proxmox Official Documentation](https://pve.proxmox.com/wiki/Main_Page)

---

## 📄 License

MIT — Free to use, modify, and distribute.

---

## ✍️ Author

Made with ❤️ by [Rohan](https://github.com/yourusername)
