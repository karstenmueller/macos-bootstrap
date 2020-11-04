#!/usr/bin/env bash

set -e
set -o pipefail
set -o nounset

# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")"/functions.sh

# install Oh My Zsh
export ZSH="$HOME"/.oh-my-zsh
rm -rf "$ZSH/custom"
CHSH='no' RUNZSH='no' KEEP_ZSHRC='yes' \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
sh "$HOME"/.oh-my-zsh/tools/upgrade.sh || true
