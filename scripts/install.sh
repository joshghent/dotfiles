#!/usr/bin/env bash

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}INFO:${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}WARN:${NC} $1"
}

log_error() {
    echo -e "${RED}ERROR:${NC} $1"
}

log_debug() {
    echo -e "${BLUE}DEBUG:${NC} $1"
}

# Detect operating system
detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "darwin" ;;
        Linux*) echo "linux" ;;
        *) echo "unknown" ;;
    esac
}

# Install prerequisites
install_prerequisites() {
    local os=$(detect_os)

    log_info "Installing prerequisites for $os..."

    case "$os" in
        darwin)
            # Check if Homebrew is installed
            if ! command -v brew >/dev/null; then
                log_info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi

            # Install yq if not present
            if ! command -v yq >/dev/null; then
                log_info "Installing yq..."
                brew install yq
            fi
            ;;
        linux)
            # Check if we're on Arch/EndeavourOS
            if command -v pacman >/dev/null; then
                log_info "Installing prerequisites for Arch/EndeavourOS..."

                # Install yq if not present
                if ! command -v yq >/dev/null; then
                    log_info "Installing yq..."
                    sudo pacman -S --noconfirm yq
                fi

                # Install git if not present
                if ! command -v git >/dev/null; then
                    log_info "Installing git..."
                    sudo pacman -S --noconfirm git
                fi
            else
                log_error "This script currently only supports Arch/EndeavourOS on Linux"
                exit 1
            fi
            ;;
        *)
            log_error "Unsupported operating system: $os"
            exit 1
            ;;
    esac
}

init_chezmoi() {
    if ! command -v chezmoi >/dev/null; then
        log_info "Installing chezmoi..."
        sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"

        # Add to PATH if not already there
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            export PATH="$HOME/.local/bin:$PATH"
        fi
    fi

    # Initialize chezmoi with the current repository
    if [ ! -d "$HOME/.local/share/chezmoi" ]; then
        log_info "Initializing chezmoi..."
        chezmoi init --source="$REPO_DIR"
    fi
}

setup_gpg() {
    log_info "Setting up GPG..."
    bash "$SCRIPT_DIR/setup_gpg.sh"
}

configure_system() {
    local os=$(detect_os)

    case "$os" in
        darwin)
            log_info "Configuring macOS..."
            bash "$SCRIPT_DIR/macos.sh"
            ;;
        linux)
            log_info "Configuring Linux..."
            bash "$SCRIPT_DIR/linux.sh"
            ;;
    esac
}

main() {
    local os=$(detect_os)
    local prerequisites_only=false

    # Parse arguments
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            prerequisites) prerequisites_only=true ;;
            *) log_error "Unknown parameter: $1"; exit 1 ;;
        esac
        shift
    done

    log_info "Starting installation for $os..."

    # Keep sudo alive
    sudo -v
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    # Install prerequisites first
    install_prerequisites

    if [ "$prerequisites_only" = true ]; then
        log_info "Prerequisites installation completed!"
        return 0
    fi

    # Configure chezmoi and user settings
    log_info "Configuring user settings..."
    bash "$SCRIPT_DIR/configure.sh"

    # Initialize chezmoi
    init_chezmoi

    # Install packages
    log_info "Installing packages..."
    bash "$SCRIPT_DIR/packages.sh"

    # Setup GPG
    setup_gpg

    # Apply dotfiles
    log_info "Applying dotfiles..."
    chezmoi apply

    # Configure system-specific settings
    configure_system

    log_info "Installation completed successfully!"
    log_info "Please restart your shell or run 'source ~/.config/fish/config.fish' to load new settings."
}

main "$@"
