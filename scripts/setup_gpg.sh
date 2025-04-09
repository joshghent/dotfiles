#!/usr/bin/env bash

# Get GPG configuration from chezmoi config
get_gpg_config() {
    local config_file="$HOME/.config/chezmoi/chezmoi.toml"
    if [ ! -f "$config_file" ]; then
        echo "Error: Chezmoi config not found" >&2
        exit 1
    }

    # Use yq to parse TOML (yq supports TOML as of v4.x)
    local email
    local name
    email=$(yq e '.data.email' "$config_file")
    name=$(yq e '.data.name' "$config_file")
    create_key=$(yq e '.data.gpg.create_key // true' "$config_file")
    key_type=$(yq e '.data.gpg.key_type // "ed25519"' "$config_file")
    key_length=$(yq e '.data.gpg.key_length // 4096' "$config_file")
    expire_days=$(yq e '.data.gpg.expire_days // 0' "$config_file")

    echo "email=$email"
    echo "name=$name"
    echo "create_key=$create_key"
    echo "key_type=$key_type"
    echo "key_length=$key_length"
    echo "expire_days=$expire_days"
}

# Check if GPG key exists for email
check_gpg_key() {
    local email="$1"
    gpg --list-secret-keys "$email" >/dev/null 2>&1
}

# Create new GPG key
create_gpg_key() {
    local name="$1"
    local email="$2"
    local key_type="$3"
    local key_length="$4"
    local expire_days="$5"

    # Create batch configuration
    cat > /tmp/gpg-batch <<EOF
    Key-Type: $key_type
    Key-Length: $key_length
    Name-Real: $name
    Name-Email: $email
    Expire-Date: ${expire_days}d
    %no-protection
    %commit
EOF

    # Generate key
    gpg --batch --generate-key /tmp/gpg-batch
    rm /tmp/gpg-batch

    # Get the key ID
    local key_id
    key_id=$(gpg --list-secret-keys --keyid-format LONG "$email" | grep sec | cut -d'/' -f2 | cut -d' ' -f1)
    echo "$key_id"
}

# Main function
main() {
    # Load configuration
    eval "$(get_gpg_config)"

    # Check if GPG key exists
    if ! check_gpg_key "$email"; then
        if [ "$create_key" = "true" ]; then
            echo "Creating new GPG key for $email..."
            key_id=$(create_gpg_key "$name" "$email" "$key_type" "$key_length" "$expire_days")
            echo "Created GPG key: $key_id"

            # Update chezmoi config with the new key
            yq e ".data.git.signingkey = \"$key_id\"" -i "$HOME/.config/chezmoi/chezmoi.toml"
        else
            echo "No GPG key found and automatic creation is disabled"
            exit 1
        fi
    else
        echo "GPG key already exists for $email"
    fi
}

main "$@"
