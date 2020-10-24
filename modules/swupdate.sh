#!/usr/bin/env bash

set -e
set -o pipefail
set -o nounset

# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")"/functions.sh

# Check and install any remaining software updates.
log "Installing software updates:"
sudo_askpass softwareupdate --install --all
xcode_license
log_ok
