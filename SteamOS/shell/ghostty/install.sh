#!/usr/bin/env bash

source "$DOTFILES/lib/common.sh"

log "Installing Ghostty configuration"

link \
    "$DOTFILES/shell/ghostty/config" \
    "$HOME/.config/ghostty/config"