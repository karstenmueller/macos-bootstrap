#!/usr/bin/env bash

set -e
set -o pipefail
set -o nounset

# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")"/functions.sh

# Install the Xcode Command Line Tools.
if ! [ -f "/Library/Developer/CommandLineTools/usr/bin/git" ]; then
    log "Installing the Xcode Command Line Tools:"
    CLT_PLACEHOLDER="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
    sudo_askpass touch "$CLT_PLACEHOLDER"

    CLT_PACKAGE=$(softwareupdate -l |
        grep -B 1 "Command Line Tools" |
        awk -F"*" '/^ *\*/ {print $2}' |
        sed -e 's/^ *Label: //' -e 's/^ *//' |
        sort -V |
        tail -n1)
    sudo_askpass softwareupdate -i "$CLT_PACKAGE"
    sudo_askpass rm -f "$CLT_PLACEHOLDER"
    if ! [ -f "/Library/Developer/CommandLineTools/usr/bin/git" ]; then
        if [ -n "$STRAP_INTERACTIVE" ]; then
            echo
            log_start "Requesting user install of Xcode Command Line Tools:"
            xcode-select --install
        else
            echo
            abort "Run 'xcode-select --install' to install the Xcode Command Line Tools."
        fi
    fi
    log_ok
fi

xcode_license
