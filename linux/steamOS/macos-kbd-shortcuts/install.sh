#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing xremap..."

mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config/xremap"
mkdir -p "$HOME/.config/systemd/user"

install -Dm755 "$ROOT/bin/xremap" \
    "$HOME/.local/bin/xremap"

install -Dm644 "$ROOT/xremap/config.yml" \
    "$HOME/.config/xremap/config.yml"

install -Dm644 "$ROOT/xremap/xremap.service" \
    "$HOME/.config/systemd/user/xremap.service"

systemctl --user daemon-reload
systemctl --user enable --now xremap.service

echo
echo "✓ xremap installed successfully."