#!/usr/bin/env bash

source "$DOTFILES/lib/common.sh"

log "Installing Zsh configuration"

link \
    "$DOTFILES/shell/zsh/.zshrc" \
    "$HOME/.zshrc"

link \
    "$DOTFILES/shell/zsh/.zsh_plugins.txt" \
    "$HOME/.config/zsh/.zsh_plugins.txt"