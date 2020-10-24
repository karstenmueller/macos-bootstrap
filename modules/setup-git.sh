#!/usr/bin/env bash

set -e
set -o pipefail
set -o nounset

# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")"/functions.sh

# Setup Git configuration.
log_start "Configuring Git:"
if [ -n "$STRAP_GIT_NAME" ] && ! git config user.name >/dev/null; then
    git config --global user.name "$STRAP_GIT_NAME"
fi

if [ -n "$STRAP_GIT_EMAIL" ] && ! git config user.email >/dev/null; then
    git config --global user.email "$STRAP_GIT_EMAIL"
fi

if [ -n "$STRAP_GITHUB_USER" ] && [ "$(git config github.user)" != "$STRAP_GITHUB_USER" ]; then
    git config --global github.user "$STRAP_GITHUB_USER"
fi

# Squelch git 2.x warning message when pushing
if ! git config push.default >/dev/null; then
    git config --global push.default simple
fi

# Setup GitHub HTTPS credentials.
if ! git credential-osxkeychain 2>&1 | grep -q "git credential-osxkeychain"; then
    if [ "$(git config --global credential.helper)" != "osxkeychain" ]; then
        git config --global credential.helper osxkeychain
    fi

    if [ -n "$STRAP_GITHUB_USER" ] && [ -n "$STRAP_GITHUB_TOKEN" ]; then
        printf "protocol=https\\nhost=github.com\\n" | git credential-osxkeychain erase
        printf "protocol=https\\nhost=github.com\\nusername=%s\\npassword=%s\\n" \
            "$STRAP_GITHUB_USER" "$STRAP_GITHUB_TOKEN" |
            git credential-osxkeychain store
    fi
fi

# configure git on macOS to properly handle line endings
git config --global core.autocrlf input

log_ok
