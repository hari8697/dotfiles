#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES/lib/common.sh"

log "Installing pacman packages"

sudo steamos-readonly disable

# Always restore SteamOS read-only mode on exit
cleanup() {
    sudo steamos-readonly enable || true
}
trap cleanup EXIT

# Rebuild pacman keyring trust database
sudo pacman-key --populate holo archlinux
sudo pacman-key --updatedb

# Update keyring and system
sudo pacman -Syu --noconfirm archlinux-keyring

# Install pacman packages
while IFS= read -r package; do
    [[ -z "$package" || "$package" =~ ^[[:space:]]*# ]] && continue

    sudo pacman -S --needed --noconfirm "$package"
done < "$DOTFILES/packages/pacman.txt"

log "Installing Flatpaks"

while IFS= read -r package; do
    [[ -z "$package" || "$package" =~ ^[[:space:]]*# ]] && continue

    flatpak install -y flathub "$package"
done < "$DOTFILES/packages/flatpak.txt"

log "Installation complete"