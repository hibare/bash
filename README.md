# Set Bash Environment

Personal development environment bootstrapper for Debian-based Linux and macOS.

## Quick Start

```shell
bash install.sh
```

## Prerequisites

- Bash 4+
- `curl`, `wget`, `sudo` access
- Debian-based system (Ubuntu, Debian, Pop!_OS, etc.) or macOS

## What Gets Installed

| Category | Linux | macOS |
|----------|-------|-------|
| Shell config | Aliases, functions, env vars, custom prompt | Same |
| Python | `python3`, `pip`, `venv`, uv, custom REPL | Same |
| Docker | Docker CE, Buildx, Compose plugin | Docker Desktop |
| Go | goenv (version manager) | Same |
| Kubernetes | kubectl (v1.33), Helm, K9s (via Docker) | Same |
| IaC | OpenTofu | Same |
| Security | pre-commit, TruffleHog | Same |
| Utilities | jq, xclip, Infisical CLI, sshpass | jq, Infisical CLI, sshpass |

## Directory Layout

- `shells/bash/` — Bash-specific rc, aliases, functions, env, profile
- `shells/zsh/` — Zsh-specific rc, aliases, functions, env, profile
- `shells/shared/` — Shared aliases, env, functions (sourced by both shells)
- `installers/` — Platform-specific and cross-platform install scripts
  - `common/` — Cross-platform tools (goenv, uv)
  - `debian/` — Debian apt-based package installation
  - `macos/` — macOS Homebrew-based package installation
- `python_config/` — Python startup script, pip configuration
- `scripts/` — Utility scripts (hadolint, tflint, Discord updater)

## Usage

### Commands

| Command | Description |
|---------|-------------|
| `make install` | Run full installation |
| `make lint` | Run shellcheck on all shell files |
| `make test` | Run bats test suite |
| `make update` | Run update scripts (Discord, hadolint, tflint) |

### Key Aliases

- `projects`, `down`, `doc` — directory shortcuts
- `d*` — Docker shortcuts (d, dstop, drm, dclist, dilist, dnone)
- `vcreate`, `vactivate` — Python venv management
- `wgup`, `wgdown`, `wgrestart` — WireGuard management
- `k9s` — Kubernetes dashboard via Docker
