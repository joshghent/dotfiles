#!/bin/bash

set -eufo pipefail

# Fix GPG directory permissions
# GPG requires strict permissions: only owner can read/write/execute

if [ -d "$HOME/.gnupg" ]; then
    echo "Fixing GPG directory permissions..."
    chmod 700 "$HOME/.gnupg"

    # Fix all files (600) and directories (700) recursively
    find "$HOME/.gnupg" -type f -exec chmod 600 {} \;
    find "$HOME/.gnupg" -type d -exec chmod 700 {} \;

    echo "GPG permissions fixed!"
else
    echo "GPG directory doesn't exist yet, will be created with correct permissions"
fi
