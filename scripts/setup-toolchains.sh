#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TOOLCHAINS_DIR="$WORKSPACE_DIR/.toolchains"

mkdir -p "$TOOLCHAINS_DIR"

# Download and extract aarch64-linux-musl-cross
if [ ! -d "$TOOLCHAINS_DIR/aarch64-linux-musl-cross" ]; then
    echo "Downloading aarch64-linux-musl-cross..."
    curl -L "https://musl.cc/aarch64-linux-musl-cross.tgz" -o "$TOOLCHAINS_DIR/aarch64-linux-musl-cross.tgz"
    echo "Extracting aarch64-linux-musl-cross..."
    tar -xzf "$TOOLCHAINS_DIR/aarch64-linux-musl-cross.tgz" -C "$TOOLCHAINS_DIR"
    rm "$TOOLCHAINS_DIR/aarch64-linux-musl-cross.tgz"
fi

# Download and extract armv7l-linux-musleabihf-cross
if [ ! -d "$TOOLCHAINS_DIR/armv7l-linux-musleabihf-cross" ]; then
    echo "Downloading armv7l-linux-musleabihf-cross..."
    curl -L "https://musl.cc/armv7l-linux-musleabihf-cross.tgz" -o "$TOOLCHAINS_DIR/armv7l-linux-musleabihf-cross.tgz"
    echo "Extracting armv7l-linux-musleabihf-cross..."
    tar -xzf "$TOOLCHAINS_DIR/armv7l-linux-musleabihf-cross.tgz" -C "$TOOLCHAINS_DIR"
    rm "$TOOLCHAINS_DIR/armv7l-linux-musleabihf-cross.tgz"
fi

echo "Toolchains setup complete."
