#!/usr/bin/env bash

set -e
set -o pipefail
set -o nounset

test -f .envrc && source .envrc

# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")"/modules/functions.sh

export CLT_PLACEHOLDER=""
export SUDO_ASKPASS=""
export STRAP_DEBUG=""
export SUDO_ASKPASS_DIR=""

STDIN_FILE_DESCRIPTOR="0"
[ -t "$STDIN_FILE_DESCRIPTOR" ] && STRAP_INTERACTIVE="1"
export STRAP_INTERACTIVE

# required env vars
trap "echo '--> Required environment variables missing!'" EXIT
STRAP_GIT_NAME=$(printenv STRAP_GIT_NAME)
STRAP_GIT_EMAIL=$(printenv STRAP_GIT_EMAIL)
STRAP_GITHUB_USER=$(printenv STRAP_GITHUB_USER)
STRAP_GITHUB_TOKEN=$(printenv STRAP_GITHUB_TOKEN)
export STRAP_GIT_NAME STRAP_GIT_EMAIL STRAP_GITHUB_USER STRAP_GITHUB_TOKEN

trap "cleanup" EXIT

[ "$USER" = "root" ] && abort "Run Strap as yourself, not root."
groups | grep -qE "\b(admin)\b" || abort "Add $USER to the admin group."

# Prevent sleeping during script execution, as long as the machine is on AC power
caffeinate -s -w $$ &

modules=(
    swupdate
    disk-encryption
    defaults
    xcode-tools
    setup-git
    oh-my-zsh
    dotfiles
    homebrew
    brewfile
)

for module in "${modules[@]}"; do
    log "Executing module: $module"
    bash "$(dirname "${BASH_SOURCE[0]}")"/modules/"$module".sh
done

log "Your system is now bootstrap'd!"
