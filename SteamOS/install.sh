#!/usr/bin/env bash

set -euo pipefail

export DOTFILES="$(cd "$(dirname "$0")" && pwd)"

INSTALL_OPENRGB=false
LUDUSAVI_PROFILE=""
STORAGE_PROFILE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h)
            cat <<EOF
SteamOS Dotfiles Installer

Usage:
  ./install.sh [options]

Required modules:
  packages
  zsh
  ghostty
  fastfetch
  macOS keyboard shortcuts

Optional modules:
  --openrgb
      Install OpenRGB configuration

  --ludusavi <profile>
      Install a Ludusavi profile

  --storage <profile>
      Install a storage profile

  -h, --help
      Show this help message
EOF
            exit 0
            ;;

        --openrgb)
            INSTALL_OPENRGB=true
            ;;

        --ludusavi)
            shift
            LUDUSAVI_PROFILE="${1:?Missing Ludusavi profile}"
            ;;

        --storage)
            shift
            STORAGE_PROFILE="${1:?Missing storage profile}"
            ;;

        *)
            echo "Unknown option: $1"
            echo
            echo "Run './install.sh --help' for usage."
            exit 1
            ;;
    esac

    shift
done

for module in \
    packages \
    shell/zsh \
    shell/ghostty \
    cli/fastfetch \
    macos-kbd-shortcuts
do
    bash "$DOTFILES/$module/install.sh"
done

# Optional modules
$INSTALL_OPENRGB && bash "$DOTFILES/apps/openrgb/install.sh"

if [[ -n "$LUDUSAVI_PROFILE" ]]; then
    LUDUSAVI_PROFILE="$LUDUSAVI_PROFILE" \
        bash "$DOTFILES/apps/ludusavi/install.sh"
fi

if [[ -n "$STORAGE_PROFILE" ]]; then
    bash "$DOTFILES/storage/install.sh" "$STORAGE_PROFILE"
fi

echo
echo "Done!"