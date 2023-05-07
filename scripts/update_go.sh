#!/bin/bash

# Get the latest version of Go
GO_LATEST_VERSION=$(curl -s -L https://golang.org/dl/ | grep -o -E 'go[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n 1)
echo "Latest release of Go: $GO_LATEST_VERSION"

# Change to tmp dir
cd /tmp

# Download the latest version of Go
echo "Downloading Go $GO_LATEST_VERSION"
wget -q https://golang.org/dl/$GO_LATEST_VERSION.linux-amd64.tar.gz

# Delete previous & unpack the archive
echo "Installing Go $GO_LATEST_VERSION"
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf $GO_LATEST_VERSION.linux-amd64.tar.gz

# Add Go to the system path if it's not already there
if ! grep -q '/usr/local/go/bin' "$HOME/.bashrc"; then
    echo "Updating path"
    echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.bashrc
fi

# Clean up
rm $GO_LATEST_VERSION.linux-amd64.tar.gz
