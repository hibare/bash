#!/bin/sh

if [ ! -n "$BASH" ]; then echo Please run this script $0 with bash; exit 1; fi

echo "Copying bash config"

cp -r bash_config/ ~/

echo "Making config directory"
mkdir -p ~/.config

echo "Creating pip directory"
mkdir -p ~/.config/pip

echo "Copying pip config"
cp -r python_config/pip/ ~/.config/pip

echo "Copying python startup file"
cp python_config/.python_startup.py ~/

echo ""
echo "Close all terminals to reload all configs or do `source ~/.bashrc"
