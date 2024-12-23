#!/bin/bash

BREW="/opt/homebrew/bin"

SYMLINKS="symlinks.txt"

BREW_CASKS="casks.lst"
BREW_LIST="brew.lst"

MAS_LIST="mas.lst"

CUR_DIR="$(pwd)"

symlinks() {
    # Read each line from the input file
    while IFS="," read -r link target; do
      # Generate and print the ln -s command
      echo "ln -s ${target} ${link}"
      if ${link}
    done < "${CUR_DIR}/${SYMLINKS}"
}


install_casks() {
    xargs brew install --casks < casks.txt
}

install_brew() {
    xargs brew install < brew.txt
}

download_synergy() {
    wget https://localhost.lu/synergy.dmg -O /tmp/synergy.dmg
}

install_synergy() {
    download_synergy
    hdiutil attach /tmp/synergy.dmg -mountpoint /Volumes/synergy
    sudo cp -R /Volumes/synergy/Synergy.app /Applications/
}

cd ~
symlinks
