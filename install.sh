#!/usr/bin/env bash

GITHUB_URL="https://raw.githubusercontent.com/abhi-g80/baksho/main/baksho-theme.sh"
BASHRC_BCK=$HOME/.bashrc.backup.$(date +"%Y-%m-%d")

usage() {
        echo "Usage: $(basename $0) [-hu]" 2>&1
        echo '   -h   shows help'
        echo '   -u   updates baksho (does not append to bashrc)'
        exit 1
}

check_curl() {
    if [ "$(command -v curl)" ]; then
        echo "curl found ✔"
    else
        echo "curl command not found, exiting ✗"
        exit 1
    fi
}

download() {
    echo -n "downloading baksho theme"
    curl -fsSL $GITHUB_URL -o "$HOME"/.baksho-theme.sh

    if [ $? -eq 0 ]; then
        echo " ✔"
    else
        echo " ✗"
        echo "could not download, please run the curl command manually"
        exit 1
    fi
}

backup() {
    echo -n "making a backup of your current bashrc"
    cp "$HOME"/.bashrc "$BASHRC_BCK" 

    if [ $? -eq 0 ]; then
        echo " ✔"
        echo "backup created at $BASHRC_BCK"
    else
        echo " ✗"
        echo "could not created backup"
        exit 1
    fi
}

append() {
    echo -n "appending to bashrc"
    echo "if [ -f ~/.baksho-theme.sh ]; then source ~/.baksho-theme.sh; fi" >> "$HOME"/.bashrc

    if [ $? -eq 0 ]; then
        echo " ✔"
        echo "done... enjoy!"
    else
        echo " ✗"
        echo "could not append"
        exit 1
    fi
}

if [ ${#} -gt 1 ]; then
   usage
fi

while getopts ":hu" o; do
    case "${o}" in
        h)
			usage
            ;;
        u)
			check_curl && download
            ;;
        *)
			check_curl && download && backup && append
            ;;
    esac
done
