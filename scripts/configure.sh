#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config/chezmoi"
CONFIG_FILE="$CONFIG_DIR/chezmoi.toml"

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

setup_ssh() {
    local email="$1"
    local os=$(detect_os)
    local ssh_key="$HOME/.ssh/id_ed25519"

    if [ ! -f "$ssh_key" ]; then
        log_info "Generating new SSH key..."
        mkdir -p "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"
        ssh-keygen -t ed25519 -C "$email" -f "$ssh_key" -N ""

        # Start ssh-agent and add key
        eval "$(ssh-agent -s)"

        # Platform-specific SSH key handling
        if [ "$os" = "darwin" ]; then
            ssh-add --apple-use-keychain "$ssh_key"
            # Copy public key to clipboard on macOS
            pbcopy < "$ssh_key.pub"
        else
            ssh-add "$ssh_key"
            # Try to copy to clipboard on Linux (requires xclip or xsel)
            if command -v xclip >/dev/null; then
                xclip -selection clipboard < "$ssh_key.pub"
            elif command -v xsel >/dev/null; then
                xsel --clipboard --input < "$ssh_key.pub"
            else
                log_warn "Could not copy SSH key to clipboard. Please copy it manually:"
                cat "$ssh_key.pub"
            fi
        fi

        log_info "SSH key generated and copied to clipboard"
        log_info "Please add this key to your GitHub/GitLab account"
        echo "Public key:"
        cat "$ssh_key.pub"
    else
        log_info "SSH key already exists at $ssh_key"
    fi
}

prompt_for_config() {
    local existing_name=""
    local existing_email=""
    local existing_personal=""

    # If chezmoi data exists, get existing values
    if chezmoi data >/dev/null 2>&1; then
        existing_name=$(chezmoi data | yq e '.name' 2>/dev/null || echo "")
        existing_email=$(chezmoi data | yq e '.email' 2>/dev/null || echo "")
        existing_personal=$(chezmoi data | yq e '.personal' 2>/dev/null || echo "false")
    fi

    # Prompt with existing values as defaults
    read -p "Enter your name [${existing_name}]: " name
    name=${name:-$existing_name}

    read -p "Enter your email [${existing_email}]: " email
    email=${email:-$existing_email}

    if [ "$existing_personal" = "true" ]; then
        default_personal="y"
    else
        default_personal="n"
    fi

    read -p "Is this a personal machine? (y/n) [${default_personal}]: " -n 1 -r is_personal
    is_personal=${is_personal:-$default_personal}
    echo

    # Return values
    echo "name=$name"
    echo "email=$email"
    echo "is_personal=${is_personal,,}"
}

create_config() {
    local name="$1"
    local email="$2"
    local is_personal="$3"
    local os=$(detect_os)

    mkdir -p "$CONFIG_DIR"

    # Create config file with cross-platform settings
    cat > "$CONFIG_FILE" <<EOF
encryption = "gpg"

[data]
    email = "$email"
    name = "$name"
    personal = $([ "$is_personal" = "y" ] && echo "true" || echo "false")
    os = "$os"

[data.gpg]
    create_key = true
    key_type = "ed25519"
    key_length = 4096
    expire_days = 0

[edit]
    command = "nvim"
EOF

    # Setup SSH key
    setup_ssh "$email"

    # Update chezmoi data
    log_info "Updating chezmoi data..."
    chezmoi add --template --exact "$CONFIG_FILE"
}

configure_user() {
    local should_configure=false

    # Check if chezmoi data exists
    if ! chezmoi data >/dev/null 2>&1; then
        log_info "Initial configuration required..."
        should_configure=true
    else
        read -p "Do you want to update your user configuration? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            should_configure=true
        fi
    fi

    if [ "$should_configure" = true ]; then
        eval "$(prompt_for_config)"
        create_config "$name" "$email" "$is_personal"
        log_info "Configuration updated successfully"

        # Show current configuration
        log_info "Current configuration:"
        chezmoi data | yq e '.name' 2>/dev/null && echo "Name: $(chezmoi data | yq e '.name')"
        chezmoi data | yq e '.email' 2>/dev/null && echo "Email: $(chezmoi data | yq e '.email')"
        chezmoi data | yq e '.personal' 2>/dev/null && echo "Personal: $(chezmoi data | yq e '.personal')"
        chezmoi data | yq e '.os' 2>/dev/null && echo "OS: $(chezmoi data | yq e '.os')"
    else
        log_info "Configuration unchanged"
    fi
}

# Main function
main() {
    # Check if yq is available
    if ! command -v yq >/dev/null; then
        log_error "yq is required but not installed. Please install yq first."
        exit 1
    fi

    configure_user
}

main "$@"
