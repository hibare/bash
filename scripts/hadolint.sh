#!/bin/bash

set -euo pipefail

# Check if Dockerfile is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <Dockerfile> [hadolint options]" >&2
  exit 1
fi

dockerfile="$1"
shift

# Check if Dockerfile exists
if [ ! -f "$dockerfile" ]; then
  echo "Error: Dockerfile '$dockerfile' not found." >&2
  exit 1
fi

# Run Hadolint
docker run --rm -i hadolint/hadolint hadolint "$@" - < "$dockerfile"
