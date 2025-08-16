#!/bin/bash

# Define paths to necessary files
BREW="/opt/homebrew/bin"
SYMLINKS="symlinks.txt"
BREW_CASKS="casks.lst"
BREW_LIST="brew.lst"
MAS_LIST="mas.lst"
CUR_DIR="$(pwd)"

# Function to create symbolic links from a file
symlinks() {
    if [[ ! -f "${CUR_DIR}/${SYMLINKS}" ]]; then
        echo "Error: ${SYMLINKS} file not found!"
        return 1
    fi

    # Read each line from the symlinks file
    while IFS="," read -r link target; do
        if [[ -z "$link" || -z "$target" ]]; then
            echo "Warning: Skipping invalid line in ${SYMLINKS}"
            continue
        fi

        # Create symbolic link if it doesn't already exist
        if [[ -L "$link" ]]; then
            echo "Symlink already exists: $link"
        else
            echo "Creating symlink: ln -s ${target} ${link}"
            ln -s "${target}" "${link}"
        fi
    done < "${CUR_DIR}/${SYMLINKS}"
}

# Function to install Homebrew casks
install_casks() {
    if [[ ! -f "${BREW_CASKS}" ]]; then
        echo "Error: ${BREW_CASKS} file not found!"
        return 1
    fi

    echo "Installing Homebrew casks..."
    xargs brew install --cask < "${BREW_CASKS}"
}

# Function to install Homebrew packages
install_brew() {
    if [[ ! -f "${BREW_LIST}" ]]; then
        echo "Error: ${BREW_LIST} file not found!"
        return 1
    fi

    echo "Installing Homebrew packages..."
    xargs brew install < "${BREW_LIST}"
}

# Function to download Synergy
download_synergy() {
    local url="https://example.com/synergy.dmg"
    local output="/tmp/synergy.dmg"

    echo "Downloading Synergy from ${url}..."
    if ! wget "${url}" -O "${output}"; then
        echo "Error: Failed to download Synergy!"
        return 1
    fi
}

# Function to install Synergy
install_synergy() {
    download_synergy || return 1

    echo "Mounting Synergy disk image..."
    if ! hdiutil attach /tmp/synergy.dmg -mountpoint /Volumes/synergy; then
        echo "Error: Failed to mount Synergy disk image!"
        return 1
    fi

    echo "Copying Synergy.app to /Applications/..."
    sudo cp -R /Volumes/synergy/Synergy.app /Applications/ || {
        echo "Error: Failed to copy Synergy.app!"
        return 1
    }

    echo "Unmounting Synergy disk image..."
    hdiutil detach /Volumes/synergy
}

# Main script execution
cd ~ || exit 1

echo "Starting setup process..."
symlinks
install_brew
install_casks
install_synergy

echo "Setup completed!"
