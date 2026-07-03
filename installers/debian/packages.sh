#!/bin/bash
# shellcheck shell=bash

set -euo pipefail

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

REPOS_CHANGED=false
KEYRINGS_DIR=/etc/apt/keyrings

apt-get install -y \
  gnupg \
  software-properties-common \
  git \
  curl \
  wget \
  build-essential \
  apt-transport-https \
  ca-certificates

install -m 0755 -d "$KEYRINGS_DIR"

# Download GPG keyring if missing
ensure_keyring() {
  local url="$1"
  local keyring="$2"

  if [ ! -f "$KEYRINGS_DIR/$keyring" ]; then
    curl -fsSL "$url" | gpg --dearmor -o "$KEYRINGS_DIR/$keyring"
    chmod 644 "$KEYRINGS_DIR/$keyring"
  fi
}

# Add a repo: source list path, source line
add_repo() {
  local source_list="$1"
  local source_line="$2"

  if [ -f "$source_list" ]; then
    echo "Repository already configured: $source_list"
    return
  fi

  echo "$source_line" | tee "$source_list" > /dev/null
  chmod 644 "$source_list"
  REPOS_CHANGED=true
}

# OpenTofu
ensure_keyring "https://get.opentofu.org/opentofu.gpg" "opentofu.gpg"
ensure_keyring "https://packages.opentofu.org/opentofu/tofu/gpgkey" "opentofu-repo.gpg"
add_repo \
  "/etc/apt/sources.list.d/opentofu.list" \
  "deb [arch=$(dpkg --print-architecture) signed-by=$KEYRINGS_DIR/opentofu.gpg,$KEYRINGS_DIR/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main"

# Docker (use Debian repo for Debian, Ubuntu repo for Ubuntu)
DOCKER_OS="ubuntu"
. /etc/os-release
if [ -n "${ID:-}" ] && [ "$ID" != "ubuntu" ]; then
  DOCKER_OS="$ID"
fi
DOCKER_CODENAME="${UBUNTU_CODENAME:-${VERSION_CODENAME}}"
ensure_keyring "https://download.docker.com/linux/${DOCKER_OS}/gpg" "docker.gpg"
add_repo \
  "/etc/apt/sources.list.d/docker.list" \
  "deb [arch=$(dpkg --print-architecture) signed-by=$KEYRINGS_DIR/docker.gpg] https://download.docker.com/linux/${DOCKER_OS} ${DOCKER_CODENAME} stable"

# Kubectl
ensure_keyring "https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key" "kubernetes.gpg"
add_repo \
  "/etc/apt/sources.list.d/kubernetes.list" \
  "deb [arch=$(dpkg --print-architecture) signed-by=$KEYRINGS_DIR/kubernetes.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /"

# Helm (via official install script — apt repo at baltocdn.com is unreliable)
if ! command -v helm &>/dev/null; then
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
  REPOS_CHANGED=true
else
  echo "helm already installed — skipping."
fi

# Infisical CLI (uses its own installer script; only run if not already configured)
if [ ! -f /etc/apt/sources.list.d/infisical-cli.list ]; then
  curl -1sLf 'https://artifacts-cli.infisical.com/setup.deb.sh' | bash
  REPOS_CHANGED=true
else
  echo "Repository already configured: infisical-cli"
fi

# Remove any stale broken repo files (baltocdn.com helm repo is defunct)
if [ -f /etc/apt/sources.list.d/helm.list ] && grep -q 'baltocdn.com/helm' /etc/apt/sources.list.d/helm.list 2>/dev/null; then
  echo "Removing stale helm baltocdn repo..."
  rm -f /etc/apt/sources.list.d/helm.list /etc/apt/keyrings/helm.gpg
  REPOS_CHANGED=true
fi

# Only update package lists if we added new repos
if [ "$REPOS_CHANGED" = true ]; then
  echo "New repositories added — updating package lists..."
  apt-get update || { echo "apt-get update failed" >&2; exit 1; }
else
  echo "All repositories already configured — skipping apt-get update."
fi

# Remove conflicting packages (batch check to avoid multiple apt calls)
CONFLICTING=""
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
  if dpkg -s "$pkg" &>/dev/null 2>&1; then
    CONFLICTING="$CONFLICTING $pkg"
  fi
done
if [ -n "$CONFLICTING" ]; then
  # shellcheck disable=SC2086
  apt-get remove -y $CONFLICTING
fi

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
  kubectl
