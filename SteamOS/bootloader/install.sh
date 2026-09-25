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

# Find or create the UEFI boot entry
if sudo efibootmgr | grep -q "Dual Boot Menu"; then
    echo "==> Dual Boot Menu EFI entry already exists"

elif sudo efibootmgr | grep -q "SteamOS Boot Menu"; then
    echo "==> Renaming SteamOS Boot Menu to Dual Boot Menu"

    BOOT_NUM="$(
        sudo efibootmgr |
        awk '/SteamOS Boot Menu/ {
            gsub(/^Boot/, "", $1)
            gsub(/\*$/, "", $1)
            print $1
            exit
        }'
    )"

    if [[ -z "$BOOT_NUM" ]]; then
        echo "ERROR: Could not determine SteamOS Boot Menu EFI entry."
        exit 1
    fi

    sudo efibootmgr -b "$BOOT_NUM" -L "Dual Boot Menu"

else
    echo "==> Creating Dual Boot Menu EFI entry"

    sudo efibootmgr -c \
        -d /dev/sdb \
        -p 3 \
        -L "Dual Boot Menu" \
        -l '\EFI\GRUB\grubx64.efi'
fi

# Find the Dual Boot Menu entry and make it first
DUAL_BOOT_NUM="$(
    sudo efibootmgr |
    awk '/Dual Boot Menu/ {
        gsub(/^Boot/, "", $1)
        gsub(/\*$/, "", $1)
        print $1
        exit
    }'
)"

if [[ -z "$DUAL_BOOT_NUM" ]]; then
    echo "ERROR: Could not find Dual Boot Menu EFI entry."
    exit 1
fi

echo "==> Setting Dual Boot Menu as first boot entry"

sudo efibootmgr -o \
    "$DUAL_BOOT_NUM",0003,000A,0000,0001

echo
echo "==> Boot entries:"
sudo efibootmgr

echo
echo "==> Bootloader installation complete."
echo "    Dual Boot Menu is the default UEFI entry."
echo "    SteamOS is the default GRUB entry."
echo "    Windows is available from the GRUB menu."