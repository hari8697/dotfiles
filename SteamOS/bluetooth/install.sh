#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICE_DIR="$HOME/.config/systemd/user"

echo "==> Installing Bluetooth auto-connect"

mkdir -p "$SERVICE_DIR"

# Make sure the script is executable
chmod +x "$DOTFILES/autoconnect.sh"

# Symlink the systemd user service into the user config
ln -sfn "$DOTFILES/bluetooth-autoconnect.service" \
    "$SERVICE_DIR/bluetooth-autoconnect.service"

# Reload user systemd
systemctl --user daemon-reload

# Enable and start the service
systemctl --user enable --now bluetooth-autoconnect.service

echo "==> Bluetooth auto-connect installed"