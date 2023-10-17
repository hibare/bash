#!/bin/bash

# Define the URL to download the latest Discord deb package
DOWNLOAD_URL="https://discord.com/api/download/stable?platform=linux&format=deb"
# Define the filename for the downloaded deb package
DEB_PACKAGE="discord.deb"

# Download the latest Discord deb package
echo "Downloading the latest Discord deb package..."
wget -O "$DEB_PACKAGE" "$DOWNLOAD_URL"

# Check if the download was successful
if [ $? -eq 0 ]; then
  echo "Download complete."
else
  echo "Download failed. Please check your internet connection or the download URL."
  exit 1
fi

# Install the downloaded package using dpkg
echo "Installing Discord..."
sudo dpkg -i "$DEB_PACKAGE"

# Check if the installation was successful
if [ $? -eq 0 ]; then
  echo "Discord has been successfully installed."
else
  echo "Installation failed. Please check for any dependency issues and try again."
fi

# Cleanup - remove the downloaded deb package
echo "Cleaning up..."
rm -f "$DEB_PACKAGE"

echo "Installation and cleanup complete."
