#!/bin/bash

set -eufo pipefail

# Fix GPG directory permissions
# GPG requires strict permissions: only owner can read/write/execute

if [ -d "$HOME/.gnupg" ]; then
    echo "Fixing GPG directory permissions..."
    chmod 700 "$HOME/.gnupg"
    chmod 600 "$HOME/.gnupg"/* 2>/dev/null || true
    echo "GPG permissions fixed!"
else
    echo "GPG directory doesn't exist yet, will be created with correct permissions"
fi
