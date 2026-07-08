#!/bin/sh
set -e

# The dotfiles are cloned and installed at runtime via postCreateCommand.
# Make sure git is present in the image so that clone can succeed.
if ! command -v git >/dev/null 2>&1; then
    echo "git not found; installing..."
    if command -v apt-get >/dev/null 2>&1; then
        apt-get update
        apt-get install -y --no-install-recommends git
        rm -rf /var/lib/apt/lists/*
    elif command -v apk >/dev/null 2>&1; then
        apk add --no-cache git
    else
        echo "WARNING: could not install git automatically; ensure it is present at runtime." >&2
    fi
fi

echo "Personal devcontainers feature installed."
