#!/usr/bin/env bash

set -e
set -o pipefail
set -o nounset

# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")"/functions.sh

# Check and enable full-disk encryption.
log_start "Checking full-disk encryption status:"
if fdesetup status | grep -q -E "FileVault is (On|Off, but will be enabled after the next restart)."; then
    log_ok
elif [ -n "$STRAP_CI" ]; then
    echo
    log_start "Skipping full-disk encryption for CI"
elif [ -n "$STRAP_INTERACTIVE" ]; then
    echo
    log "Enabling full-disk encryption on next reboot:"
    sudo_askpass fdesetup enable -user "$USER" |
        tee ~/Desktop/"FileVault Recovery Key.txt"
    log_ok
else
    echo
    abort "Run 'sudo fdesetup enable -user \"$USER\"' to enable full-disk encryption."
fi
