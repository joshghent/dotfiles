#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config/chezmoi"
CONFIG_FILE="$CONFIG_DIR/chezmoi.toml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

setup_ssh() {
    local email="$1"
    local ssh_key="$HOME/.ssh/id_ed25519"

    if [ ! -f "$ssh_key" ]; then
        log_info "Generating new SSH key..."
        mkdir -p "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"
        ssh-keygen -t ed25519 -C "$email" -f "$ssh_key" -N ""

        # Start ssh-agent and add key
        eval "$(ssh-agent -s)"
        ssh-add --apple-use-keychain "$ssh_key"

        # Copy public key to clipboard
        pbcopy < "$ssh_key.pub"
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
    local existing_type=""

    # If config exists, get existing values
    if [ -f "$CONFIG_FILE" ]; then
        existing_name=$(yq e '.data.name' "$CONFIG_FILE")
        existing_email=$(yq e '.data.email' "$CONFIG_FILE")
        existing_type=$(yq e '.data.machine_type // "work"' "$CONFIG_FILE")
    fi

    # Prompt with existing values as defaults
    read -p "Enter your name [${existing_name}]: " name
    name=${name:-$existing_name}

    read -p "Enter your email [${existing_email}]: " email
    email=${email:-$existing_email}

    if [ "$existing_type" = "personal" ]; then
        default_machine="y"
    else
        default_machine="n"
    fi

    read -p "Is this a personal machine? (y/n) [${default_machine}]: " -n 1 -r is_personal
    is_personal=${is_personal:-$default_machine}
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

    mkdir -p "$CONFIG_DIR"

    # Create config file
    cat > "$CONFIG_FILE" <<EOF
encryption = "gpg"

[data]
    email = "$email"
    name = "$name"
    machine_type = "$([ "$is_personal" = "y" ] && echo "personal" || echo "work")"

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
}

configure_user() {
    local should_configure=false

    if [ ! -f "$CONFIG_FILE" ]; then
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
    else
        log_info "Configuration unchanged"
    fi
}

# Main function
main() {
    configure_user
}

main "$@"
