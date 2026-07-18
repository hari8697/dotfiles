#!/usr/bin/env bash

set -euo pipefail

export DOTFILES="$(cd "$(dirname "$0")" && pwd)"

INSTALL_STORAGE=false
INSTALL_OPENRGB=false
LUDUSAVI_PROFILE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
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
            exit 1
            ;;
    esac

    shift
done

"$DOTFILES/packages/install.sh"
"$DOTFILES/shell/zsh/install.sh"
"$DOTFILES/shell/ghostty/install.sh"
"$DOTFILES/cli/fastfetch/install.sh"
"$DOTFILES/macos-kbd-shortcuts/install.sh"

# Optional modules
$INSTALL_STORAGE && "$DOTFILES/storage/install.sh"
$INSTALL_OPENRGB && "$DOTFILES/apps/openrgb/install.sh"
if [[ -n "$LUDUSAVI_PROFILE" ]]; then
    LUDUSAVI_PROFILE="$LUDUSAVI_PROFILE" \
        "$DOTFILES/apps/ludusavi/install.sh"
fi
if [[ -n "$STORAGE_PROFILE" ]]; then
    "$DOTFILES/storage/install.sh" "$STORAGE_PROFILE"
fi

echo
echo "Done!"