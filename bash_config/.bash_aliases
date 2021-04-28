# Custom aliases
PS1='\[\e[96m\][\d \t]:\[\e[93m\]\w\$ \[\e[0m\]'

# Alias Related
alias myaliases='cat ~/.bash_aliases'
alias sc='source ~/.bashrc'

# cd
alias ..='cd ..'
alias ...='cd ../../'
alias ~='cd ~'
alias project='cd ~/Documents/projects'
alias down='cd ~/Downloads'
alias doc='cd ~/Documents'

# SSH
alias sshadd='cd ~/.ssh && ssh-add id_rsa && cd -'

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

alias hc='echo "" > logs/app.log && honcho start'

# Wireguard
alias wgdown='sudo wg-quick down wg0'
alias wgup='sudo wg-quick up wg0'
alias wg='sudo wg'
alias wgcheck='nslookup x.secure'


# IP
alias myip='curl http://ipinfo.io'