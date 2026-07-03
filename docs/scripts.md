# Scripts Reference

## `install.sh`

Entrypoint for the bootstrap. Detects OS (Linux/macOS) and shell (bash/zsh), copies config files to `$HOME`, dispatches to the appropriate platform installer, and runs cross-platform installers.

Flags:
- `--skip-packages` — config-only, skip package installation

## `installers/debian/packages.sh`

Installs development tools on Debian-based systems. Adds third-party repos and installs via `apt-get`.
Requires root privileges.

## `installers/macos/packages.sh`

Installs development tools on macOS via Homebrew.

## `installers/common/goenv.sh`

Cross-platform Go version manager installer (`go-nv/goenv`).

## `installers/common/uv.sh`

Cross-platform uv (Python package manager) installer.

## `scripts/update_discord.sh`

Downloads and installs the latest Discord .deb package (Debian-only).

## `scripts/hadolint.sh`

Wraps the hadolint Dockerfile linter. Passes a Dockerfile through `hadolint/hadolint` container.

Usage: `./scripts/hadolint.sh <Dockerfile> [hadolint options]`
