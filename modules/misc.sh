#!/usr/bin/env bash

set -e
set -o pipefail
set -o nounset

# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")"/functions.sh

# tools not available vai Homebrew
sudo_askpass pip3 install awshelper https://codeload.github.com/boto/botocore/zip/v2
sudo_askpass pip3 install requests

log_ok
