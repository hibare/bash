# shellcheck shell=bash
# Custom prompt
PS1='\[\e[96m\][\d \t]:\[\e[93m\]\w\$ \[\e[0m\]'

# Source shared shell config
for f in "$HOME/.shell_config/aliases" "$HOME/.shell_config/env" "$HOME/.shell_config/functions"; do
  if [[ -f "${f}" ]]; then
    # shellcheck disable=SC1090
    source "${f}"
  fi
done

# goenv (Go version manager)
if command -v goenv &>/dev/null; then
  eval "$(goenv init -)"
fi

# Only set these in interactive shells
if [[ -z "${PS1:-}" ]]; then
  return
fi
