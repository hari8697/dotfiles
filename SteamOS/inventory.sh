#!/usr/bin/env bash

echo "========== PACMAN =========="
pacman -Qe

echo
echo "========== FLATPAKS =========="
flatpak list --app

echo
echo "========== USER SERVICES =========="
systemctl --user list-unit-files --state=enabled

echo
echo "========== SYSTEM SERVICES =========="
systemctl list-unit-files --state=enabled

echo
echo "========== SHELL =========="
echo "$SHELL"

echo
echo "========== ZSHRC =========="
cat ~/.zshrc

echo
echo "========== GHOSTTY =========="
cat ~/.config/ghostty/config

echo
echo "========== FASTFETCH =========="
cat ~/.config/fastfetch/config.jsonc

echo
echo "========== FSTAB =========="
cat /etc/fstab

echo
echo "========== UDEV =========="
ls /etc/udev/rules.d
cat /etc/udev/rules.d/*.rules 2>/dev/null