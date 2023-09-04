#!/usr/bin/env bash

set -e
set -o pipefail
set -o nounset

# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")"/functions.sh

# Setup Homebrew directory and permissions.
log_start "Installing Homebrew:"
HOMEBREW_PREFIX="$(brew --prefix 2>/dev/null || true)"
[ -n "$HOMEBREW_PREFIX" ] || HOMEBREW_PREFIX="/usr/local"
[ -d "$HOMEBREW_PREFIX" ] || sudo_askpass mkdir -p "$HOMEBREW_PREFIX"
if [ "$HOMEBREW_PREFIX" = "/usr/local" ]; then
    sudo_askpass chown "root:wheel" "$HOMEBREW_PREFIX" 2>/dev/null || true
fi
(
    cd "$HOMEBREW_PREFIX"
    sudo_askpass mkdir -p Cellar Frameworks bin etc include lib opt sbin share var
    sudo_askpass chown -R "$USER:admin" Cellar Frameworks bin etc include lib opt sbin share var
)

HOMEBREW_REPOSITORY="$(brew --repository 2>/dev/null || true)"
[ -n "$HOMEBREW_REPOSITORY" ] || HOMEBREW_REPOSITORY="/usr/local/Homebrew"
[ -d "$HOMEBREW_REPOSITORY" ] || sudo_askpass mkdir -p "$HOMEBREW_REPOSITORY"
sudo_askpass chown -R "$USER:admin" "$HOMEBREW_REPOSITORY"

if [ "$HOMEBREW_PREFIX" != "$HOMEBREW_REPOSITORY" ]; then
    ln -sf "$HOMEBREW_REPOSITORY/bin/brew" "$HOMEBREW_PREFIX/bin/brew"
fi

# Download Homebrew.
export GIT_DIR="$HOMEBREW_REPOSITORY/.git" GIT_WORK_TREE="$HOMEBREW_REPOSITORY"
git init -q
git config remote.origin.url "https://github.com/Homebrew/brew"
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch -q --tags --force
git reset -q --hard origin/master
unset GIT_DIR GIT_WORK_TREE
log_ok

# Update Homebrew.
export PATH="$HOMEBREW_PREFIX/bin:$PATH"
log "Updating Homebrew:"
brew update
log_ok

# Install from Brewfile
if [ -e "$HOME/.Brewfile" ]; then
    log "Installing from Brewfile:"
    brew bundle check --global || brew bundle --global
    log_ok
fi
