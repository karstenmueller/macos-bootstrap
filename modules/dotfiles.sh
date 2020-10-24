#!/usr/bin/env bash

set -e
set -o pipefail
set -o nounset

# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")"/functions.sh

# Given a list of scripts in the dotfiles repo, run the first one that exists
run_dotfile_scripts() {
    if [ -d ~/.dotfiles ]; then
        (
            cd ~/.dotfiles
            for i in "$@"; do
                if [ -f "$i" ] && [ -x "$i" ]; then
                    log "Running dotfiles $i:"
                    "$i"
                    break
                fi
            done
        )
    fi
}

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
        log_ok
    fi
fi

pushd ~/.dotfiles >/dev/null
log "--> syncing ~/.dotfiles to $HOME/"
rsync --exclude ".git/" \
    --exclude ".DS_Store" \
    --exclude "script/" \
    --exclude ".oh-my-zsh" \
    --exclude "*.md" \
    --exclude "*.txt" \
    -avh --no-perms . $HOME/
popd >/dev/null
log_ok

run_dotfile_scripts script/setup script/bootstrap
log_ok
