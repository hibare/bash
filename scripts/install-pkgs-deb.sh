#!/bin/bash

# Install on debian based systems
# Check for debian based system
if ! command -v apt-get &> /dev/null; then
  echo "This script is intended for Debian-based systems (like Ubuntu)."
  exit 1
fi

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo or as root."
  exit 1
fi

apt-get update
apt-get install -y \
  gnupg \
  software-properties-common \
  git \
  curl \
  wget \
  build-essential \
  apt-transport-https \
  ca-certificates

install -m 0755 -d /etc/apt/keyrings

# Infisical CLI
curl -1sLf 'https://artifacts-cli.infisical.com/setup.deb.sh' | bash

# OpenTofu
curl -fsSL https://get.opentofu.org/opentofu.gpg | gpg --dearmor -o /etc/apt/keyrings/opentofu.gpg
curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | gpg --dearmor -o /etc/apt/keyrings/opentofu-repo.gpg
chmod 644 /etc/apt/keyrings/opentofu.gpg /etc/apt/keyrings/opentofu-repo.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" | \
  tee /etc/apt/sources.list.d/opentofu.list > /dev/null
chmod 644 /etc/apt/sources.list.d/opentofu.list

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod 644 /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
chmod 644 /etc/apt/sources.list.d/docker.list

# Kubectl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes.gpg
chmod 644 /etc/apt/keyrings/kubernetes.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/kubernetes.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /" | \
  tee /etc/apt/sources.list.d/kubernetes.list > /dev/null
chmod 644 /etc/apt/sources.list.d/kubernetes.list

# Helm
curl -fsSL https://baltocdn.com/helm/signing.asc | gpg --dearmor -o /etc/apt/keyrings/helm.gpg
chmod 644 /etc/apt/keyrings/helm.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | \
  tee /etc/apt/sources.list.d/helm.list > /dev/null
chmod 644 /etc/apt/sources.list.d/helm.list

# Update package lists after adding new repositories
apt-get update

# Remove conflicting packages
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
  apt-get remove -y $pkg
done

# Install required packages
apt-get install -y \
  python3 \
  python3-pip \
  python3-venv \
  jq \
  xclip \
  pre-commit \
  infisical \
  sshpass \
  tofu \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin \
  kubectl \
  helm


# Install poetry
curl -sSL https://install.python-poetry.org | python3 -

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh
