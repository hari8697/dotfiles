#!/usr/bin/env bash

source "$DOTFILES/lib/common.sh"

: "${LUDUSAVI_PROFILE:?LUDUSAVI_PROFILE is not set}"

CONFIG="$DOTFILES/apps/ludusavi/$LUDUSAVI_PROFILE/config.yaml"

if [[ ! -f "$CONFIG" ]]; then
    echo "Unknown Ludusavi profile: $LUDUSAVI_PROFILE"
    exit 1
fi

log "Installing Ludusavi ($LUDUSAVI_PROFILE)"

link \
    "$CONFIG" \
    "$HOME/.var/app/com.github.mtkennerly.ludusavi/config/ludusavi/config.yaml"