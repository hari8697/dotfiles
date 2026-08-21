#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GRUB_CFG="$SCRIPT_DIR/grub.cfg"

echo "==> Installing bootloader"

if command -v steamos-readonly >/dev/null 2>&1; then
    sudo steamos-readonly disable
fi

if ! mountpoint -q /efi; then
    echo "ERROR: /efi is not mounted."
    exit 1
fi

if [[ -f /boot/grub/grub.cfg && ! -L /boot/grub/grub.cfg ]]; then
    BACKUP="/boot/grub/grub.cfg.backup.$(date +%Y%m%d-%H%M%S)"
    echo "==> Backing up existing grub.cfg to $BACKUP"
    sudo cp /boot/grub/grub.cfg "$BACKUP"
fi

echo "==> Installing GRUB configuration"

sudo cp "$GRUB_CFG" /boot/grub/grub.cfg

echo "==> Checking GRUB configuration"

sudo grub-script-check /boot/grub/grub.cfg

if sudo efibootmgr | grep -q "SteamOS Boot Menu"; then
    echo "==> SteamOS Boot Menu EFI entry already exists"
else
    echo "==> Creating SteamOS Boot Menu EFI entry"

    sudo efibootmgr -c \
        -d /dev/sdb \
        -p 3 \
        -L "SteamOS Boot Menu" \
        -l '\EFI\GRUB\grubx64.efi'
fi

echo
echo "==> Boot entries:"
sudo efibootmgr

echo
echo "==> Bootloader installation complete."
echo "    SteamOS is the default."
echo "    Windows is available from the GRUB menu."