#!/usr/bin/env bash

set -e
set -o pipefail
set -o nounset

# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")"/functions.sh

if [ -n "$STRAP_GITHUB_USER" ]; then
    BINDIR_URL="https://github.com/$STRAP_GITHUB_USER/bin"

    if git ls-remote "$BINDIR_URL" &>/dev/null; then
        log "Fetching $STRAP_GITHUB_USER/bin from GitHub:"
        if [ ! -d "$HOME/.bin" ]; then
            log "Cloning to ~/.bin:"
            git clone -q "$BINDIR_URL" ~/.bin
        else
            (
                log "git pull in ~/.bin:"
                cd ~/.bin
                git pull -q
            )
        fi
        log_ok
    fi
fi
