# Source aliases and functions
if [ -f "$HOME/.bash_aliases" ]; then
  source "$HOME/.bash_aliases"
fi

if [ -f "$HOME/.bash_env" ]; then
  source "$HOME/.bash_env"
fi

if [ -f "$HOME/.bash_functions" ]; then
  source "$HOME/.bash_functions"
fi

# Python (consider using direnv or conda instead)
export PYTHONSTARTUP="$HOME/.python_startup.py"

# Go config
export GOPRIVATE="*.hibare.in"
export GOPATH="$HOME/go"
export GONOPROXY="github.com/hibare"

# SSL
export SSL_CERT_DIR="/etc/ssl/certs"

# Export GPG key
export GPG_TTY=$(tty)

# Dev flags
export IS_LOCAL=true

# PATH modifications: Combine into one
export PATH="/usr/local/go/bin:$GOPATH/bin:$HOME/.local/bin:$PATH"

# Terminal settings
export TERM="xterm-256color"
export LC_ALL="en_US.UTF-8"

# Only set these in interactive shells
if [ -z "$PS1" ]; then
  # Non-interactive shell settings
  return
fi
