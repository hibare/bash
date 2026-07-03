#!/bin/bash
# shellcheck shell=bash
# Cross-platform uv (Python package manager) installer

set -euo pipefail

if command -v uv &>/dev/null; then
  echo "uv already installed — skipping."
  exit 0
fi

echo "Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh
