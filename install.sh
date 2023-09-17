#!/bin/sh

if [ ! -n "$BASH" ]; then echo Please run this script $0 with bash; exit 1; fi

# Install requirements
sudo apt-get update
sudo apt-get install xclip -y

command -v jq &> /dev/null || { echo "jq is not installed. Installing..."; sudo apt-get install -y jq; }

echo "Copying bash config"

cp -R bash_config/. ~/

echo "Making config directory"
mkdir -p ~/.config

echo "Creating pip directory"
mkdir -p ~/.config/pip

echo "Copying pip config"
cp -R python_config/pip/. ~/.config/pip

echo "Copying python startup file"
cp python_config/.python_startup.py ~/

echo "Making system script directory"
mkdir -p ~/.system_scripts

echo "Copying system_scripts"
cp -R scripts/. ~/.system_scripts

echo ""
echo "Close all terminals to reload all configs or do source ~/.bashrc"
