# shellcheck shell=bash
# Custom prompt
PROMPT='%F{cyan}[%D{%a %b %d} %D{%H:%M:%S}]:%F{yellow}%~%#%f '

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
