#!/usr/bin/env bash

source "$DOTFILES/lib/common.sh"

require_sudo

PROFILE="${1:?Missing storage profile}"

SOURCE="$DOTFILES/storage/$PROFILE/fstab"

if [[ ! -f "$SOURCE" ]]; then
    echo "Storage profile '$PROFILE' does not exist."
    exit 1
fi

log "Installing storage profile ($PROFILE)"

TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

if [[ -f /etc/fstab ]]; then
    log "Backing up /etc/fstab"
    sudo cp /etc/fstab "/etc/fstab.$TIMESTAMP.bak"
fi

log "Installing new fstab"
sudo install -m 644 "$SOURCE" /etc/fstab

log "Reloading systemd"
sudo systemctl daemon-reload

log "Mounting filesystems"
if ! sudo mount -av; then
    echo
    echo "Warning: One or more filesystems failed to mount."
    echo "Check 'dmesg' for details."
fi

log "Storage profile installed."