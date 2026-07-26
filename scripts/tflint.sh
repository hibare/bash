#!/bin/bash
# shellcheck shell=bash

set -euo pipefail

# If no arguments, pass nothing to tflint (shows tflint help)
if [ $# -eq 0 ]; then
  exec docker run --rm -v "$PWD:/data" -t ghcr.io/terraform-linters/tflint
fi

# If first argument is a flag (starts with -), pass everything straight
# through to tflint in Docker, mounting the current directory.
# This handles pre-commit invocations like:
#   tflint --init
#   tflint --chdir=path args...
#   tflint --format json
if [[ "$1" == -* ]]; then
  exec docker run --rm -v "$PWD:/data" -t ghcr.io/terraform-linters/tflint "$@"
fi

# Interactive mode: first argument is a target directory
target="$1"
shift

if [ ! -d "$target" ]; then
  echo "Error: Terraform directory '$target' not found." >&2
  exit 1
fi

if [ ! -f "$target/.tflint.hcl" ]; then
  echo "Warning: No .tflint.hcl found in '$target'. TFLint may not work as expected without configuration." >&2
fi

exec docker run --rm -v "$(cd "$target" && pwd):/data" -t ghcr.io/terraform-linters/tflint "$@"
