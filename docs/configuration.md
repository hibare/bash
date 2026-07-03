# Configuration Guide

## Environment Variables

Set these in `shells/shared/env` (shared between shells) or `shells/bash/.bash_env` / `shells/zsh/.zshenv` (shell-specific):

| Variable | Default | Purpose |
|----------|---------|---------|
| `GOPRIVATE` | `*.hibare.in` | Go private module pattern |
| `GONOPROXY` | `github.com/hibare` | Go no-proxy pattern |
| `IS_LOCAL` | `true` | Local development flag |
| `PYTHONSTARTUP` | `$HOME/.python_startup.py` | Python startup script |
| `SSL_CERT_DIR` | `/etc/ssl/certs` | SSL certificate directory |

## Aliases

Add or modify aliases in `shells/shared/aliases` (shared by both shells), or in `shells/bash/.bash_aliases` / `shells/zsh/.zsh_aliases` for shell-specific overrides.
Key groups: Docker, Python, WireGuard, directory navigation, Kubernetes.

## Functions

Add or modify shell functions in `shells/shared/functions` (shared), or `shells/bash/.bash_functions` / `shells/zsh/.zsh_functions`.
Built-in: `hadolint`, `update_discord`, `gen_env_example`, `settitle`.
