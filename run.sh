#!/usr/bin/env bash

set -e
set -o pipefail
set -o nounset

DIR="$(dirname "${BASH_SOURCE[0]}")"
module=${1:-} # Use $1 to test single

# shellcheck source=/dev/null
test -f "$DIR"/.envrc && source "$DIR"/.envrc

# shellcheck source=/dev/null
source "$DIR"/modules/functions.sh

export CLT_PLACEHOLDER=""
export SUDO_ASKPASS=""
export STRAP_DEBUG=""
export SUDO_ASKPASS_DIR=""

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
    bindir
    misc
)

STDIN_FILE_DESCRIPTOR="0"
[ -t "$STDIN_FILE_DESCRIPTOR" ] && STRAP_INTERACTIVE="1"
export STRAP_INTERACTIVE

# check required environment variables
trap "echo '--> Required environment variable missing!'" EXIT
STRAP_GIT_NAME=$(printenv STRAP_GIT_NAME)
STRAP_GIT_EMAIL=$(printenv STRAP_GIT_EMAIL)
STRAP_GITHUB_USER=$(printenv STRAP_GITHUB_USER)
STRAP_GITHUB_TOKEN=$(printenv STRAP_GITHUB_TOKEN)
export STRAP_GIT_NAME STRAP_GIT_EMAIL STRAP_GITHUB_USER STRAP_GITHUB_TOKEN

trap "cleanup" EXIT

[ "$USER" = "root" ] && abort "Execute with your account, not as root."
groups | grep -qE "\b(admin)\b" || abort "Add $USER to the admin group."

# prevent sleeping during script execution, as long as the machine is on AC power
caffeinate -s -w $$ &

if [ "$module" != "" ]; then
    modules=()
    modules[0]="$module"
fi

for module in "${modules[@]}"; do
    log "Executing module: $module"
    if test -r "$module"; then
        bash "$module"
    else
        bash "$(dirname "${BASH_SOURCE[0]}")"/modules/"$module".sh
    fi
done

log "Your system is now bootstrap'd!"
