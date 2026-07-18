#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing xremap"

mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config/xremap"
mkdir -p "$HOME/.config/systemd/user"

echo "==> Symlinking xremap binary"
ln -sfn "$ROOT/bin/xremap" \
    "$HOME/.local/bin/xremap"

chmod +x "$ROOT/bin/xremap"

echo "==> Symlinking configuration"
ln -sfn "$ROOT/xremap/config.yml" \
    "$HOME/.config/xremap/config.yml"

echo "==> Symlinking systemd service"
ln -sfn "$ROOT/xremap/xremap.service" \
    "$HOME/.config/systemd/user/xremap.service"

echo "==> Reloading systemd"
systemctl --user daemon-reload

echo "==> Enabling xremap"
systemctl --user enable xremap.service

echo "==> Restarting xremap"
systemctl --user restart xremap.service

echo
echo "✓ xremap installed"