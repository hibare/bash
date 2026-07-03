# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
make install   # Run full installation (copies configs, installs packages)
make lint      # Run shellcheck on all shell files
make test      # Run bats test suite (requires: npm install -g bats)
make update    # Run update scripts (Discord, hadolint)
```

### Single test

```bash
bats tests/<test-file>.bats
```

### Lint a specific file

```bash
shellcheck --shell=bash path/to/file.sh
```

## Architecture Overview

### Purpose

Personal development environment bootstrapper for Debian-based Linux and macOS. Installs shell configs, dev tooling (Python, Docker, Kubernetes, IaC, security tools), and utility scripts.

### Shell Config Layout — Multi-Shell Shared Design

Both bash and zsh configs follow the same pattern: per-shell files (`~/.bashrc`, `~/.zshrc`) source a shared directory at `~/.shell_config/` containing `aliases`, `env`, and `functions`. This avoids duplicating common config across shells.

```
shells/
├── bash/        → copied to $HOME/       (e.g. .bashrc, .bash_aliases, .bash_env)
├── zsh/         → copied to $HOME/       (e.g. .zshrc, .zshenv, .zsh_aliases)
└── shared/      → copied to $HOME/.shell_config/  (aliases, env, functions)
```

Each per-shell file sources the shared layer. Per-shell files are thin wrappers that set a custom prompt then source shared config. Shell-specific alias/function/env files exist as forward-compatibility wrappers that also source the shared equivalents.

### Platform Detection

`install.sh` detects the OS (`uname -s`) and shell (`$SHELL`) at startup, then dispatches:

- **Linux**: runs `installers/debian/packages.sh` via sudo
- **macOS**: runs `installers/macos/packages.sh` (without sudo, via Homebrew)
- **Common**: runs `installers/common/goenv.sh` and `installers/common/uv.sh` on both platforms

### Install Flow (`install.sh`)

1. Detects OS (linux/macos) and shell (bash/zsh)
2. Copies `shells/bash/*` or `shells/zsh/*` to `$HOME/` depending on detected shell
3. Copies `shells/shared/*` to `$HOME/.shell_config/`
4. Copies `python_config/pip/` to `$HOME/.config/pip/`
5. Copies `python_config/.python_startup.py` to `$HOME/`
6. Copies `scripts/*` to `$HOME/.system_scripts/` (chmod +x)
7. Runs platform package installer (Debian apt or macOS Homebrew)
8. Runs cross-platform installers (goenv, uv)

### Key Scripts

| Script                          | Purpose                                                                                                           |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `install.sh`                    | Bootstrap entrypoint — detects OS/shell, copies configs, dispatches installers                                    |
| `installers/debian/packages.sh` | Adds third-party repos (Docker, k8s, Helm, OpenTofu, Infisical) and installs packages via apt-get. Requires root. |
| `installers/macos/packages.sh`  | Installs packages via Homebrew. No sudo required.                                                                 |
| `installers/common/goenv.sh`    | Cross-platform Go version manager                                                                                 |
| `installers/common/uv.sh`       | Cross-platform Python package manager (uv)                                                                        |
| `scripts/update_discord.sh`     | Downloads and installs latest Discord .deb (Debian-only)                                                          |
| `scripts/hadolint.sh`           | Wraps hadolint Dockerfile linter via Docker (`hadolint/hadolint` image)                                           |

### Common Conventions

- All shell scripts use `set -euo pipefail` and `# shellcheck shell=bash`
- No `set -x` or verbose mode in production scripts
- `.shellcheckrc` disables SC1090 (dynamic sources), SC1091 (sourced files not in CI), SC2154 (vars from sourced files); enables all other checks
- `.editorconfig`: 2-space indent for shell files, 4-space for Python, tabs for Makefile
- Aliases prefixed by domain: `d*` for Docker, `wg*` for WireGuard, `v*` for Python venv

### Tests (bats)

Tests use `bats` (Bash Automated Testing System). Each test file in `tests/` mirrors a script in `installers/`, `scripts/`, or the install flow. Tests validate error handling (wrong shell, missing args, missing files, root requirement) rather than full end-to-end execution.

Test pattern:

```bash
setup() {
  PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
}
```

### CI Pipeline (GitHub Actions)

Two jobs in `.github/workflows/checks.yml`:

- **pre-commit**: runs all pre-commit hooks (shellcheck, trufflehog, file checks)
- **test**: runs `bats tests/` on ubuntu-latest and macos-latest (runs cross-platform tests automatically)

Dependabot manages monthly updates for GitHub Actions and pre-commit dependencies. Release drafter auto-generates changelogs from conventional commit labels.
