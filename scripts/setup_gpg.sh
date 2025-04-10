#!/usr/bin/env bash

main() {
    current_keys=$(gpg --list-secret-keys --keyid-format=long)

    # Check if there are any current keys
    if [[ -z "$current_keys" ]]; then
        echo "No existing GPG keys found. Generating new key..."
        # Generate the key
        gpg --full-generate-key
    fi

    # Extract the key ID using grep and awk
    # This looks for lines containing "sec" and extracts the key ID
    key_id=$(gpg --list-secret-keys --keyid-format=long | grep sec | awk '{print $2}' | awk -F'/' '{print $2}')

    if [[ -n "$key_id" ]]; then
        echo "Found GPG key ID: $key_id"
        gpg --armor --export "$key_id"
        echo "$key_id" > ~/.local/share/chezmoi/private_gpg_key_id
    else
        echo "Failed to find GPG key ID"
        exit 1
    fi
}

main "$@"
