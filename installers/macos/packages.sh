#!/bin/bash
# shellcheck shell=bash
# macOS Homebrew package installer

set -euo pipefail

# Check for macOS
if [[ "$(uname -s)" != Darwin ]]; then
  echo "This script is intended for macOS."
  exit 1
fi

# Install Homebrew if missing
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Verify Homebrew installation
if ! command -v brew &>/dev/null; then
  echo "Homebrew installation failed. Please install Homebrew manually and try again." >&2
  exit 1
fi

# Update Homebrew
echo "Updating Homebrew..."
brew update

# Install packages
echo "Installing packages..."

brew install \
  jq \
  pre-commit \
  python \
  sshpass \
  kubectl \
  helm \
  infisical \
  opentofu

brew install --cask \
  docker

echo "macOS package installation complete."
