#!/usr/bin/env bash

set -euo pipefail

export DOTFILES="$(cd "$(dirname "$0")" && pwd)"

clear

echo "SteamOS Dotfiles Installer"
echo
echo "Select modules to install:"
echo
echo "  1) Packages"
echo "  2) Bluetooth"
echo "  3) Zsh"
echo "  4) Ghostty"
echo "  5) Fastfetch"
echo "  6) macOS Keyboard Shortcuts"
echo "  7) OpenRGB"
echo "  8) Ludusavi"
echo "  9) Storage"
echo " 10) Bootloader"
echo " 11) Install All"
echo " 12) Exit"
echo

read -rp "Enter selection(s) [e.g. 1 3 5]: " -a SELECTIONS

if [[ ${#SELECTIONS[@]} -eq 0 ]]; then
    echo
    echo "No selection made."
    exit 1
fi

INSTALL_ALL=false

INSTALL_PACKAGES=false
INSTALL_BLUETOOTH=false
INSTALL_ZSH=false
INSTALL_GHOSTTY=false
INSTALL_FASTFETCH=false
INSTALL_MACOS_KBD=false
INSTALL_OPENRGB=false
INSTALL_LUDUSAVI=false
INSTALL_STORAGE=false
INSTALL_BOOTLOADER=false

for selection in "${SELECTIONS[@]}"; do
    case "$selection" in
        1) INSTALL_PACKAGES=true ;;
        2) INSTALL_BLUETOOTH=true ;;
        3) INSTALL_ZSH=true ;;
        4) INSTALL_GHOSTTY=true ;;
        5) INSTALL_FASTFETCH=true ;;
        6) INSTALL_MACOS_KBD=true ;;
        7) INSTALL_OPENRGB=true ;;
        8) INSTALL_LUDUSAVI=true ;;
        9) INSTALL_STORAGE=true ;;
        10) INSTALL_BOOTLOADER=true ;;
        11) INSTALL_ALL=true ;;
        12)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo
            echo "Invalid selection: $selection"
            exit 1
            ;;
    esac
done

# Install everything
if [[ "$INSTALL_ALL" == true ]]; then
    INSTALL_PACKAGES=true
    INSTALL_BLUETOOTH=true
    INSTALL_ZSH=true
    INSTALL_GHOSTTY=true
    INSTALL_FASTFETCH=true
    INSTALL_MACOS_KBD=true
    INSTALL_OPENRGB=true
    INSTALL_LUDUSAVI=true
    INSTALL_STORAGE=true
    INSTALL_BOOTLOADER=true
fi

# Ask for required profiles
LUDUSAVI_PROFILE=""
STORAGE_PROFILE=""

if [[ "$INSTALL_LUDUSAVI" == true ]]; then
    echo
    read -rp "Ludusavi profile: " LUDUSAVI_PROFILE

    if [[ -z "$LUDUSAVI_PROFILE" ]]; then
        echo "Error: Ludusavi profile is required."
        exit 1
    fi
fi

if [[ "$INSTALL_STORAGE" == true ]]; then
    echo
    read -rp "Storage profile: " STORAGE_PROFILE

    if [[ -z "$STORAGE_PROFILE" ]]; then
        echo "Error: Storage profile is required."
        exit 1
    fi
fi

run_module() {
    local module="$1"

    echo
    echo "==> Installing $module"
    bash "$DOTFILES/$module/install.sh"
}

# Install selected modules

[[ "$INSTALL_PACKAGES" == true ]] &&
    run_module "packages"

[[ "$INSTALL_BLUETOOTH" == true ]] &&
    run_module "bluetooth"

[[ "$INSTALL_ZSH" == true ]] &&
    run_module "shell/zsh"

[[ "$INSTALL_GHOSTTY" == true ]] &&
    run_module "shell/ghostty"

[[ "$INSTALL_FASTFETCH" == true ]] &&
    run_module "cli/fastfetch"

[[ "$INSTALL_MACOS_KBD" == true ]] &&
    run_module "macos-kbd-shortcuts"

[[ "$INSTALL_OPENRGB" == true ]] &&
    run_module "apps/openrgb"

if [[ "$INSTALL_LUDUSAVI" == true ]]; then
    echo
    echo "==> Installing Ludusavi profile: $LUDUSAVI_PROFILE"

    LUDUSAVI_PROFILE="$LUDUSAVI_PROFILE" \
        bash "$DOTFILES/apps/ludusavi/install.sh"
fi

if [[ "$INSTALL_STORAGE" == true ]]; then
    echo
    echo "==> Installing storage profile: $STORAGE_PROFILE"

    bash "$DOTFILES/storage/install.sh" "$STORAGE_PROFILE"
fi

[[ "$INSTALL_BOOTLOADER" == true ]] &&
    run_module "bootloader"

echo
echo "Done!"