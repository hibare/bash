#!/bin/bash

set -euo pipefail

# Log function
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Get the latest version of Go
log "Checking for the latest Go version..."
GO_LATEST_VERSION=$(curl -s -L https://golang.org/dl/ | grep -o -E 'go[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n 1)
if [ -z "$GO_LATEST_VERSION" ]; then
  log "Error: Could not determine the latest Go version."
  exit 1
fi
log "Latest release of Go: $GO_LATEST_VERSION"

# Define the download URL and archive name
DOWNLOAD_URL="https://golang.org/dl/$GO_LATEST_VERSION.linux-amd64.tar.gz"
ARCHIVE_NAME="$GO_LATEST_VERSION.linux-amd64.tar.gz"

# Change to tmp dir
log "Changing to /tmp directory..."
cd /tmp

# Download the latest version of Go
log "Downloading Go $GO_LATEST_VERSION..."
wget -q "$DOWNLOAD_URL"

# Check if the download was successful
if [ ! -f "$ARCHIVE_NAME" ]; then
  log "Error: Download failed. Please check your internet connection or the URL."
  exit 1
fi

# Delete previous & unpack the archive
log "Installing Go $GO_LATEST_VERSION..."
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "$ARCHIVE_NAME"

# Add Go to the system path if it's not already there
if ! grep -q '/usr/local/go/bin' "$HOME/.bashrc"; then
    log "Updating path in $HOME/.bashrc"
    echo 'export PATH=$PATH:/usr/local/go/bin' >> "$HOME/.bashrc"
fi

# Clean up
log "Cleaning up..."
rm "$ARCHIVE_NAME"
log "Go has been successfully installed. Please restart your terminal or run 'source $HOME/.bashrc' to update your PATH."
