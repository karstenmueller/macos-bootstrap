#!/usr/bin/env bash

SUDO_ASKPASS=""

sudo_askpass() {
    if [ -f "$SUDO_ASKPASS" ]; then
        sudo --askpass "$@"
    else
        sudo "$@"
    fi
}

cleanup() {
    set +e
    sudo_askpass rm -rf "$CLT_PLACEHOLDER" "$SUDO_ASKPASS" "$SUDO_ASKPASS_DIR"
    # sudo --reset-timestamp
}

# Initialise (or reinitialise) sudo to save unhelpful prompts later.
sudo_init() {
    local SUDO_PASSWORD SUDO_PASSWORD_SCRIPT

    if ! sudo --validate --non-interactive &>/dev/null; then
        while true; do
            read -rsp "--> Enter your password (for sudo access):" SUDO_PASSWORD
            echo
            if sudo --validate --stdin 2>/dev/null <<<"$SUDO_PASSWORD"; then
                break
            fi

            unset SUDO_PASSWORD
            echo "!!! Wrong password!" >&2
        done

        SUDO_PASSWORD_SCRIPT="$(
            cat <<BASH
#!/bin/bash
echo "$SUDO_PASSWORD"
BASH
        )"
        unset SUDO_PASSWORD
        SUDO_ASKPASS_DIR="$(mktemp -d)"
        SUDO_ASKPASS="$(mktemp "$SUDO_ASKPASS_DIR"/strap-askpass-XXXXXXXX)"
        chmod 700 "$SUDO_ASKPASS_DIR" "$SUDO_ASKPASS"
        bash -c "cat > '$SUDO_ASKPASS'" <<<"$SUDO_PASSWORD_SCRIPT"
        unset SUDO_PASSWORD_SCRIPT
        export SUDO_ASKPASS
    fi
}

sudo_refresh() {
    if [ -f "$SUDO_ASKPASS" ]; then
        sudo --askpass --validate
    else
        sudo_init
    fi
}

abort() {
    echo "!!! $*" >&2
    exit 1
}
log() {
    sudo_refresh
    echo "--> $*"
}
log_start() {
    sudo_refresh
    printf -- "--> %s " "$*"
}
log_ok() {
    echo "OK"
}
escape() {
    printf '%s' "${1//\'/\'}"
}

# Check if the Xcode license is agreed to and agree if not.
xcode_license() {
    if /usr/bin/xcrun clang 2>&1 | grep -q license; then
        if [ -n "$STRAP_INTERACTIVE" ]; then
            log_start "Asking for Xcode license confirmation:"
            sudo_askpass xcodebuild -license
            log_ok
        else
            abort "Run 'sudo xcodebuild -license' to agree to the Xcode license."
        fi
    fi
}
