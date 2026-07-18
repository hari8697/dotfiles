#!/usr/bin/env bash

source "$DOTFILES/lib/common.sh"

log "Installing pacman packages"

sudo steamos-readonly disable

while IFS= read -r package; do
    [[ -z "$package" || "$package" =~ ^# ]] && continue
    sudo pacman -S --needed --noconfirm "$package"
done < "$DOTFILES/packages/pacman.txt"

sudo steamos-readonly enable

log "Installing Flatpaks"

while IFS= read -r package; do
    [[ -z "$package" || "$package" =~ ^# ]] && continue
    flatpak install -y flathub "$package"
done < "$DOTFILES/packages/flatpak.txt"