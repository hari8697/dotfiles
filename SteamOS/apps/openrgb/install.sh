#!/usr/bin/env bash

source "$DOTFILES/lib/common.sh"

log "Installing OpenRGB"

CONFIG_DIR="$HOME/.var/app/org.openrgb.OpenRGB/config/OpenRGB"

mkdir -p "$CONFIG_DIR"

link \
    "$DOTFILES/apps/openrgb/OpenRGB.json" \
    "$CONFIG_DIR/OpenRGB.json"

for profile in "$DOTFILES"/apps/openrgb/profiles/*.orp; do
    [[ -e "$profile" ]] || continue

    link \
        "$profile" \
        "$CONFIG_DIR/$(basename "$profile")"
done