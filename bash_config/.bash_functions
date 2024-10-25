settitle() {
    echo -n -e "\033]0;$1\007"
}

update_go() {
    sh ~/.system_scripts/update_go.sh
}

update_discord() {
    sh ~/.system_scripts/update_discord.sh
}

hadolint() {
    sh ~/.system_scripts/hadolint.sh
}
gen_env_example() {
    # Check if .env file exists
    if [ ! -f .env ]; then
        echo ".env file not found!"
        exit 1
    fi

    # Create or overwrite .env.example file
    > .env.example

    # Read .env file line by line
    while IFS= read -r line; do
        # Skip empty lines and comments
        if [[ -z "$line" || "$line" == \#* ]]; then
            echo "$line" >> .env.example
        else
            # Extract the key
            key=$(echo "$line" | cut -d '=' -f 1)
            # Write the key=<VALUE> format to .env.example
            echo "$key=<VALUE>" >> .env.example
        fi
    done < .env

    echo ".env.example file has been created."
}
