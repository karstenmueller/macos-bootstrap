#!/usr/bin/env bash

set -e
set -o pipefail
set -o nounset

# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")"/functions.sh

# Setup Brewfile
if [ -n "$STRAP_GITHUB_USER" ] && { [ ! -f "$HOME/.Brewfile" ] || [ "$HOME/.Brewfile" -ef "$HOME/.homebrew-brewfile/Brewfile" ]; }; then
    HOMEBREW_BREWFILE_URL="https://github.com/$STRAP_GITHUB_USER/homebrew-brewfile"

    if git ls-remote "$HOMEBREW_BREWFILE_URL" &>/dev/null; then
        log "Fetching $STRAP_GITHUB_USER/homebrew-brewfile from GitHub:"
        if [ ! -d "$HOME/.homebrew-brewfile" ]; then
            log "Cloning to ~/.homebrew-brewfile:"
            git clone -q "$HOMEBREW_BREWFILE_URL" ~/.homebrew-brewfile
            log_ok
        else
            (
                cd ~/.homebrew-brewfile
                git pull -q
            )
        fi
        ln -sf ~/.homebrew-brewfile/Brewfile ~/.Brewfile
        log_ok
    fi
fi

# Install from local Brewfile
if [ -f "$HOME/.Brewfile" ]; then
    log "Installing from user Brewfile on GitHub:"
    brew bundle check --global || brew bundle --global
    log_ok
fi

# Tap a custom Homebrew tap
if [ -n "$CUSTOM_HOMEBREW_TAP" ]; then
    read -ra CUSTOM_HOMEBREW_TAP <<<"$CUSTOM_HOMEBREW_TAP"
    log "Running 'brew tap ${CUSTOM_HOMEBREW_TAP[*]}':"
    brew tap "${CUSTOM_HOMEBREW_TAP[@]}"
    log_ok
fi
