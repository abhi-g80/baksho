#!/usr/bin/env bash

GITHUB_URL="https://raw.githubusercontent.com/abhi-g80/baksho/main/baksho-theme.sh"
BASHRC_BCK=$HOME/.bashrc.backup.$(date +"%Y-%m-%d")

__print() {
    if [ "$1" == "ok" ]; then
        echo "✔ $2"
    else
        echo "✗ $2"
    fi
}

if [ "$(command -v curl)" ]; then
    __print ok "downloading baksho theme"
else
    __print bad "curl command not found, exiting"
    exit 1
fi

curl -fsSL $GITHUB_URL -o "$HOME"/.baksho-theme.sh

if [ $? -eq 0 ]; then
    __print ok "download complete"
else
    __print bad "could not download, please run the curl command manually"
    exit 1
fi

__print ok "making a backup of your current bashrc"

cp "$HOME"/.bashrc "$BASHRC_BCK" 

if [ $? -eq 0 ]; then
    __print ok "backup created at $BASHRC_BCK"
else
    __print bad "could not created backup"
    exit 1
fi

__print ok "appending to bashrc"

echo "if [ -f ~/.baksho-theme.sh ]; then source ~/.baksho-theme.sh; fi" >> "$HOME"/.bashrc

if [ $? -eq 0 ]; then
    __print ok "done... enjoy!"
else
    __print bad "could not append"
    exit 1
fi
