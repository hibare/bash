#!/bin/bash

# Check if the script is running with bash
if [ -z "$BASH" ]; then
  echo "Please run this script with bash."
  exit 1
fi

# Function to copy files and directories
copy_files() {
  local source_dir="$1"
  local target_dir="$2"
  echo "Copying '$source_dir' to '$target_dir'"
  cp -r "$source_dir" "$target_dir"
}

# Copy configurations and files
echo "Copying bash config"
copy_files "bash_config/." "$HOME/"

echo "Making config directory"
mkdir -p "$HOME/.config"

echo "Creating pip directory"
mkdir -p "$HOME/.config/pip"

echo "Copying pip config"
copy_files "python_config/pip/." "$HOME/.config/pip"

echo "Copying python startup file"
cp "python_config/.python_startup.py" "$HOME/"

echo "Making system script directory"
mkdir -p "$HOME/.system_scripts"


echo "Copying system_scripts"
copy_files "scripts/." "$HOME/.system_scripts"

# Set execute permissions on scripts
chmod +x "$HOME/.system_scripts/*"

# Source bashrc
echo "Sourcing .bashrc"
source "$HOME/.bashrc"

# Install packages
echo "Installing packages for Debian-based systems"
sudo "$HOME/.system_scripts/install-pkgs-deb.sh"

# Provide instructions to the user
echo -e "\nConfiguration setup is complete. Please restart your terminal or run 'source $HOME/.bashrc' to apply the changes."
