#!/usr/bin/env bash

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

init_chezmoi() {
    if ! command -v chezmoi >/dev/null; then
        echo "Installing chezmoi..."
        sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    fi

    chezmoi init --source="$REPO_DIR/home"
}

main() {
    sudo -v
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    # Configure chezmoi first
    bash "$SCRIPT_DIR/configure.sh"

    init_chezmoi

    # Install packages first (includes gpg)
    bash "$SCRIPT_DIR/packages.sh"

    # Setup GPG
    bash "$SCRIPT_DIR/setup_gpg.sh"

    # Apply dotfiles
    chezmoi apply

    # Configure macOS
    bash "$SCRIPT_DIR/macos.sh"
}

main "$@"
