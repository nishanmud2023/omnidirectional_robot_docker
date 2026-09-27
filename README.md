# 🐳 Student Project Docker Template

A ready-to-use Docker workspace for student projects. Clone this repo, configure your packages and repos, and get everyone on the same environment in minutes.

---

## 📁 File Structure

```
.
├── docker/
│   ├── Dockerfile                  # Container definition
│   ├── install_docker.sh           # Install Docker and optional NVIDIA support
│   ├── build_docker.sh             # Build the container image
│   ├── run_docker.sh               # Run the container
│   ├── into_docker.sh              # Enter the running container shell
│   ├── .dockerignore
│   └── scripts/
│       ├── install_system.sh       # apt/pip packages installed at build time
│       ├── install_docker.sh       # System docker installation
│       ├── entrypoint.sh           # Container entrypoint
│       └── clone_repos.sh          # GitHub repos cloned at build time
├── .env                           # Configuration file (APP_NAME, etc.)
├── .gitignore
└── workspace/                        # Your local workspace, mounted into container
```

---

## 🚀 Quick Start

### Prerequisites
- [Docker](https://docs.docker.com/get-docker/) installed and running
- For GPU support: [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-docker)

### 1 — Clone this template and install Docker

```bash
git clone https://github.com/your-org/your-template.git my-project
cd my-project
```

Install Docker (if not already installed):

```bash
source docker/install_docker.sh
```

For NVIDIA GPU support, add the `-n` flag:

```bash
source docker/install_docker.sh -n
```

### 2 — Configure your workspace

| File | What to edit |
|------|-------------|
| `.env` | Set `APP_NAME` to your application name (e.g., `my-app`) |
| `docker/scripts/install_system.sh` | Add apt packages, pip packages, or other tools |
| `docker/scripts/clone_repos.sh` | Add GitHub repos to clone into the workspace |

### 3 — Build the container

Build the container image:

```bash
source docker/build_docker.sh
```

For NVIDIA GPU support, add the `-n` flag:

```bash
source docker/build_docker.sh -n
```

### 4 — Run the container

Start the container:

```bash
source docker/run_docker.sh
```

For NVIDIA GPU support, add the `-n` flag:

```bash
source docker/run_docker.sh -n
```

The `run_docker.sh` script automatically sets up:
- **X11 display forwarding** — GUI applications inside the container appear on your host desktop
- **USB device access** — connect peripheral devices (e.g., robot hardware, sensors)
- **Bluetooth support** — wireless device connectivity
- **Host network mode** — container shares the host's network interface
- **Privileged mode** — required for accessing hardware devices
- **Volume mount** — `./workspace/` synced at `/workspace` inside the container

### 5 — Enter the container shell

Open a bash shell inside the running container:

```bash
source docker/into_docker.sh
```

Your local `./workspace/` folder is mounted at `/workspace` inside the container — changes sync both ways instantly.

---

## ⚙️ Configuration

### Base Image

The default base image is **`ubuntu:22.04`**. To use a different base image, edit the `FROM` statement in [docker/Dockerfile](docker/Dockerfile).

### NVIDIA GPU Support

All bash scripts support the `-n` or `--nvidia` flag for NVIDIA GPU containers:

```bash
source docker/install_docker.sh -n    # Install with NVIDIA support
source docker/build_docker.sh -n       # Build GPU-enabled image
source docker/run_docker.sh -n         # Run with GPU access
```

### Environment Variables

Configure your application in the `.env` file:

```bash
APP_NAME=my-app    # Used for image name and container name
```

---

## 🎮 Hardware & Peripherals

The container is configured to access host hardware and peripherals:

- **GPU** — Use `-n` flag to enable NVIDIA GPU support
- **USB Devices** — Automatic access to USB peripherals (e.g., robots, sensors, microcontrollers)
- **Bluetooth** — Wireless device connectivity enabled
- **GUI Applications** — X11 display forwarding lets GUI apps run inside the container and display on your host
- **Host Networking** — Container uses the host's network stack for direct network access

---

## 🔒 Private GitHub Repositories
 
Access private repos by adding an SSH key to your GitHub account. The SSH key will be copied into the container at build time.
 
### 1 — Generate an SSH key (skip if you already have one)
 
```bash
ssh-keygen -t ed25519
# Press Enter to accept the default path (~/.ssh/id_ed25519)
# Set a passphrase or leave empty
```
 
### 2 — Add the public key to GitHub
 
Copy your public key:
```bash
cat ~/.ssh/id_ed25519.pub
```
 
Then go to **GitHub → Settings → SSH and GPG keys → New SSH key**, paste it in, and save.
 
### 3 — SSH key is automatically mounted at build time
 
The `build_docker.sh` script automatically detects and copies your SSH keys into the container. This allows cloning of private repositories during the build process.
 
### 4 — Use SSH URLs in `docker/scripts/clone_repos.sh`
 
```bash
git clone git@github.com:your-org/private-repo.git /path/in/container
```
 
> **Note:** SSH keys are copied into the image for use during build time to clone private repositories.
 
---
 


---

## 💾 Volume / Persistent Storage

The `workspace/` directory on your host machine is bind-mounted into the container at `/workspace`. This means:

- **Your files survive container restarts** — nothing is lost when you stop the container.
- **Edit locally, run inside Docker** — use your favourite editor on your machine while code executes in the container.


---

## 🛠️ Common Commands

```bash
# Rebuild after changing Dockerfile or installation scripts
source docker/build_docker.sh

# Open a new shell in a running container
source docker/into_docker.sh

# Stop the container (press Ctrl+C in the container shell or use docker stop)
docker stop $APP_NAME

# Remove the image (replace 'my-app' with your APP_NAME)
docker rmi "$APP_NAME"-img

# View container logs
docker logs $APP_NAME
```

---

## 📝 Customisation Checklist

- [ ] Edit `.env` — set your `APP_NAME` to your project name
- [ ] Edit `docker/scripts/install_system.sh` — add your project's apt/pip packages
- [ ] Edit `docker/scripts/clone_repos.sh` — list the repos students need
- [ ] Update the `LABEL maintainer` line in `docker/Dockerfile`
- [ ] Update this README with project-specific instructions
- [ ] Ensure SSH keys are in `~/.ssh/` if using private repositories

---

## 📄 Quick Reference

| Task | Command |
|------|---------|
| Install Docker + NVIDIA support | `source docker/install_docker.sh -n` |
| Build container | `source docker/build_docker.sh` |
| Run container with GPU | `source docker/run_docker.sh -n` |
| Enter container shell | `source docker/into_docker.sh` |
| Stop container | `docker stop $APP_NAME` |
| Rebuild after config changes | `source docker/build_docker.sh` |
