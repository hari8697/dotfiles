#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/lib/common.sh"

log "Installing Fastfetch configuration"

link \
    "$DOTFILES/cli/fastfetch/config.jsonc" \
    "$HOME/.config/fastfetch/config.jsonc"