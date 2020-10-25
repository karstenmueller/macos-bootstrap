#!/usr/bin/env bash

set -e
set -o pipefail
set -o nounset

# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")"/functions.sh

# use name and email for logim message
if [ -n "$STRAP_GIT_NAME" ] && [ -n "$STRAP_GIT_EMAIL" ]; then
    LOGIN_TEXT=$(escape "Found this computer? Please contact $STRAP_GIT_NAME at $STRAP_GIT_EMAIL.")
    echo "$LOGIN_TEXT" | grep -q '[()]' && LOGIN_TEXT="'$LOGIN_TEXT'"
    sudo_askpass defaults write /Library/Preferences/com.apple.loginwindow \
        LoginwindowText \
        "$LOGIN_TEXT"
fi

# configure some basic security settings
log_start "Configuring security settings:"
defaults write com.apple.Safari \
    com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled \
    -bool false
defaults write com.apple.Safari \
    com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles \
    -bool false
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
sudo_askpass defaults write /Library/Preferences/com.apple.alf globalstate -int 1
sudo_askpass launchctl load /System/Library/LaunchDaemons/com.apple.alf.agent.plist 2>/dev/null

# location for Screenshots
defaults write com.apple.screencapture location ~/Downloads

# autohide Dock
defaults write com.apple.dock autohide -bool true

log_ok
