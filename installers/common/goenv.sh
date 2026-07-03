#!/bin/bash
# shellcheck shell=bash
# Cross-platform Go version manager installer

set -euo pipefail

GOENV_SHA="66571a3851c83e1341dce284aba907964c3d6a48"

if command -v goenv &>/dev/null; then
  echo "goenv already installed — skipping."
  exit 0
fi

if [[ -f "${HOME}/.goenv/bin/goenv" ]]; then
  echo "goenv already installed — skipping."
  exit 0
fi

echo "Installing goenv..."
curl -sfL "https://raw.githubusercontent.com/go-nv/goenv/${GOENV_SHA}/install.sh" | bash
