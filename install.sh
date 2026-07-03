#!/bin/bash
# shellcheck shell=bash

set -euo pipefail

SKIP_PACKAGES=false

usage() {
  echo "Usage: $0 [--skip-packages]"
  echo "  --skip-packages    Skip system package installation (config only)"
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-packages) SKIP_PACKAGES=true ;;
    --help|-h) usage ;;
    *) echo "Unknown option: $1"; usage ;;
  esac
  shift
done

# Check if the script is running with bash
if [[ -z "${BASH:-}" ]]; then
  echo "Please run this script with bash."
  exit 1
fi

# Detect the user's default shell
detect_shell() {
  local user_shell
  user_shell=$(basename "${SHELL:-}")
  if [ -n "$user_shell" ]; then
    echo "$user_shell"
  elif command -v zsh &>/dev/null; then
    echo "zsh"
  else
    echo "bash"
  fi
}

# Detect operating system
detect_os() {
  case "$(uname -s)" in
    Linux)  echo "linux" ;;
    Darwin) echo "macos" ;;
    *)      echo "unsupported" ;;
  esac
}

CURRENT_SHELL=$(detect_shell)
CURRENT_OS=$(detect_os)
echo "Detected OS: $CURRENT_OS"
echo "Detected shell: $CURRENT_SHELL"

# Function to copy files and directories
copy_files() {
  local source_dir="$1"
  local target_dir="$2"
  if [[ ! -d "$source_dir" ]]; then
    echo "Warning: source directory '$source_dir' not found — skipping."
    return
  fi
  echo "Copying '$source_dir' to '$target_dir'"
  cp -R "$source_dir" "$target_dir"
}

# Copy configurations and files for the detected shell
case "$CURRENT_SHELL" in
  bash)
    echo "Installing bash config"
    copy_files "shells/bash/." "$HOME/"
    ;;
  zsh)
    echo "Installing zsh config"
    copy_files "shells/zsh/." "$HOME/"
    ;;
  *)
    echo "Unsupported shell: $CURRENT_SHELL. Installing bash config as fallback."
    copy_files "shells/bash/." "$HOME/"
    ;;
esac

echo "Copying shared shell config"
mkdir -p "$HOME/.shell_config"
copy_files "shells/shared/." "$HOME/.shell_config"

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
chmod +x "$HOME"/.system_scripts/*

# Install platform packages (unless skipped)
if [[ "$SKIP_PACKAGES" = true ]]; then
  echo "Skipping package installation (--skip-packages flag set)."
else
  case "$CURRENT_OS" in
    linux)
      echo "Installing packages for Debian-based system"
      sudo bash "installers/debian/packages.sh"
      ;;
    macos)
      echo "Installing packages for macOS"
      bash "installers/macos/packages.sh"
      ;;
    *)
      echo "Unsupported OS: $CURRENT_OS. Skipping package installation."
      ;;
  esac
fi

# Install cross-platform tools (no sudo needed)
bash installers/common/goenv.sh
bash installers/common/uv.sh

# Source the installed shell rc
if [[ "$CURRENT_SHELL" = "zsh" ]]; then
  echo "Sourcing .zshrc"
  # shellcheck source=/dev/null
  source "$HOME/.zshrc" 2>/dev/null || echo "Warning: could not source .zshrc"
else
  echo "Sourcing .bashrc"
  # shellcheck source=/dev/null
  source "$HOME/.bashrc" 2>/dev/null || echo "Warning: could not source .bashrc"
fi

# Provide instructions to the user
echo -e "\nConfiguration setup is complete. Please restart your terminal or run 'source $HOME/.bashrc' to apply the changes."
