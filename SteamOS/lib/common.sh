#!/usr/bin/env bash

set -euo pipefail

: "${DOTFILES:?DOTFILES is not set}"

log() {
    printf "\n==> %s\n" "$1"
}

link() {
    local source="$1"
    local target="$2"

    mkdir -p "$(dirname "$target")"

    if [[ -L "$target" ]]; then
        echo "↺ Relinking $target"
    elif [[ -e "$target" ]]; then
        echo "⚠ Backing up $target -> $target.bak"
        mv "$target" "$target.bak"
    else
        echo "➜ Linking $target"
    fi

    ln -sfn "$source" "$target"
}

require_sudo() {
    sudo -v || exit 1
}