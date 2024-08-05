if [ -f $HOME/.bash_aliases ]; then
    source $HOME/.bash_aliases
fi

if [ -f $HOME/.bash_env ]; then
    source $HOME/.bash_env
fi

if [ -f $HOME/.bash_functions ]; then
    source $HOME/.bash_functions
fi

# Python
export PYTHONSTARTUP=~/.python_startup.py
export PATH=$PATH:$HOME/.local/bin

export TERM=xterm-256color

export LC_ALL="en_US.UTF-8"

# Go config
export GOPRIVATE=*.hibare.in
export GOPATH=$HOME/go
export GONOPROXY=github.com/hibare
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# SSL
export SSL_CERT_DIR=/etc/ssl/certs

eval "$(starship init bash)"

# Export GPG key
export GPG_TTY=$(tty)

# Dev flags
export IS_LOCAL=true