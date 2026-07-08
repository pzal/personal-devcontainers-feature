#!/bin/sh
set -e

# Make sure git is present in the image so the runtime clone can succeed.
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

# Copy the runtime bootstrap script to a persistent location. The feature's
# build directory is temporary and gone by the time postCreateCommand runs,
# so it can't be executed from here directly.
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
BOOTSTRAP_DIR=/usr/local/share/personal-devcontainers-feature
mkdir -p "$BOOTSTRAP_DIR"
cp "$SCRIPT_DIR/bootstrap.sh" "$BOOTSTRAP_DIR/bootstrap.sh"
chmod +x "$BOOTSTRAP_DIR/bootstrap.sh"

echo "Personal devcontainers feature installed."
