#!/bin/bash

set -euo pipefail

# Define variables
DOWNLOAD_URL="https://discord.com/api/download/stable?platform=linux&format=deb"
DEB_PACKAGE="discord.deb"

# Log function
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Download the latest Discord deb package
log "Downloading the latest Discord deb package..."
wget -q -O "$DEB_PACKAGE" "$DOWNLOAD_URL"

# Check if the download was successful
if [ ! -f "$DEB_PACKAGE" ]; then
  log "Download failed. Please check your internet connection or the download URL."
  exit 1
fi

log "Download complete."

# Install the downloaded package using dpkg, resolving dependencies
log "Installing Discord..."
sudo apt update
sudo apt install -f ./"$DEB_PACKAGE"

# Check if the installation was successful
if [ $? -ne 0 ]; then
  log "Installation failed. Please check for any dependency issues and try again."
  exit 1
fi

log "Discord has been successfully installed."

# Cleanup - remove the downloaded deb package
log "Cleaning up..."
rm -f "$DEB_PACKAGE"

log "Installation and cleanup complete."
