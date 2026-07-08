#!/bin/sh
set -e

# Runtime bootstrap, invoked by postCreateCommand once the container exists and
# $HOME is known. The host dirs are bind-mounted to fixed paths under /mnt
# (the container's $HOME is not known when the mounts are written, especially in
# the Docker Compose flow), so we symlink them into the real home here.
for name in .claude .codex; do
    src="/mnt/personal-devcontainers-feature/$name"
    dest="$HOME/$name"
    if [ -e "$src" ]; then
        # Replace an existing real dir/file so the symlink lands correctly.
        [ -e "$dest" ] && [ ! -L "$dest" ] && rm -rf "$dest"
        ln -sfn "$src" "$dest"
    fi
done

# Clone and install dotfiles.
if [ ! -d "$HOME/dotfiles/.git" ]; then
    git clone https://github.com/pzal/dotfiles.git "$HOME/dotfiles"
fi
cd "$HOME/dotfiles" && ./install.sh
