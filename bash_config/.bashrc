if [ -f $HOME/.bash_aliases ]; then
    source $HOME/.bash_aliases
fi

if [ -f $HOME/.bash_env ]; then
    source $HOME/.bash_env
fi

if [ -f $HOME/.bash_functions ]; then
    source $HOME/.bash_functions
fi

export PYTHONSTARTUP=~/.python_startup.py

export TERM=xterm-256color
