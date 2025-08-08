# Custom prompt
PS1='\[\e[96m\][\d \t]:\[\e[93m\]\w\$ \[\e[0m\]'

# Alias Management
alias myaliases='cat $HOME/.bash_aliases'
alias sc='source $HOME/.bashrc'

# Directory Navigation
alias ..='cd ..'
alias ...='cd ../../'
alias ~='cd ~'
alias projects='cd $HOME/Documents/projects'
alias down='cd $HOME/Downloads'
alias doc='cd $HOME/Documents'

# SSH
alias sshadd='cd $HOME/.ssh && ssh-add id_rsa && cd -'

# Docker
alias d='docker'
alias dnone='docker rmi $(docker images -f "dangling=true" -q)'
alias dstop='docker stop $(docker ps -a -q)'
alias drm='docker rm $(docker ps -a -q)'
alias dclist='docker ps -a'
alias dilist='docker images'

# Python
alias pip_uninstall_all='pip freeze | xargs pip uninstall -y'
alias py='python'
alias py3='python3'
alias vactivate='source venv/bin/activate'
alias vcreate='virtualenv -p python3 venv'

# Wireguard
alias wgcheck='nslookup int.hibare.in'
alias wgdown='sudo wg-quick down wg0'
alias wgup='sudo wg-quick up wg0 && wgcheck'
alias wg='sudo wg'
alias wgrestart='wgdown && wgup'

# IP Address
alias myip='curl -sfl https://ip.09876543.xyz/api/v1/ip/ | jq'

# Mac equivalent of copy/paste commands
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# Kubernetes
alias k9s='docker run --rm -it -v ~/.kube/config:/root/.kube/config quay.io/derailed/k9s'
