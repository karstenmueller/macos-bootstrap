#!/usr/bin/env bash

set -e
set -o pipefail
set -o nounset

# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")"/functions.sh

# Setup Brewfile
if [ -n "$STRAP_GITHUB_USER" ] && { [ ! -f "$HOME/.Brewfile" ] || [ "$HOME/.Brewfile" -ef "$HOME/.homebrew/Brewfile" ]; }; then
    HOMEBREW_BREWFILE_URL="https://github.com/$STRAP_GITHUB_USER/homebrew"

    if git ls-remote "$HOMEBREW_BREWFILE_URL" &>/dev/null; then
        log "Fetching $STRAP_GITHUB_USER/homebrew from GitHub:"
        if [ ! -d "$HOME/.homebrew" ]; then
            log "Cloning to ~/.homebrew:"
            git clone -q "$HOMEBREW_BREWFILE_URL" ~/.homebrew
            log_ok
        else
            (
                cd ~/.homebrew
                git pull -q
            )
        fi
        ln -sf ~/.homebrew/.Brewfile ~/.Brewfile
        log_ok
    fi
fi

# Install from Brewfile
if [ -e "$HOME/.Brewfile" ]; then
    log "Installing from Brewfile:"
    brew bundle check --global || brew bundle --global
    log_ok
fi
