#!/usr/bin/env bash

set -e
set -o pipefail
set -o nounset

# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")"/functions.sh

# Setup dotfiles
if [ -n "$STRAP_GITHUB_USER" ]; then
    DOTFILES_URL="https://github.com/$STRAP_GITHUB_USER/dotfiles"

    if git ls-remote "$DOTFILES_URL" &>/dev/null; then
        log "Fetching $STRAP_GITHUB_USER/dotfiles from GitHub:"
        if [ ! -d "$HOME/.dotfiles" ]; then
            log "Cloning to ~/.dotfiles:"
            git clone -q "$DOTFILES_URL" ~/.dotfiles
        else
            (
                cd ~/.dotfiles
                git pull -q --rebase --autostash
            )
        fi
        run_dotfile_scripts script/setup script/bootstrap
        log_ok
    fi
fi
