settitle() {
  echo -n -e "\033]0;$1\007"
}

update_go() {
  $HOME/.system_scripts/update_go.sh
  if [ $? -ne 0 ]; then
    echo "Error: update_go.sh failed" >&2
    return 1
  fi
}

update_discord() {
  $HOME/.system_scripts/update_discord.sh
  if [ $? -ne 0 ]; then
    echo "Error: update_discord.sh failed" >&2
    return 1
  fi
}

hadolint() {
  $HOME/.system_scripts/hadolint.sh
  if [ $? -ne 0 ]; then
    echo "Error: hadolint.sh failed" >&2
    return 1
  fi
}

gen_env_example() {
  if [ ! -f .env ]; then
    echo ".env file not found!" >&2
    return 1
  fi

  # Use sed to create .env.example
  sed -E 's/=.*$/=<VALUE>/' .env > .env.example

  echo ".env.example file has been created."
}
