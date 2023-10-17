settitle() {
    echo -n -e "\033]0;$1\007"
}

update_go() {
    sh ~/.system_scripts/update_go.sh
}

update_discord() {
    sh ~/.system_scripts/update_discord.sh
}