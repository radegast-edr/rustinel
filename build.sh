#!/usr/bin/env bash
set -euo pipefail

# Ensure patch version is 1
export RADEGAST_PATCH_VERSION="1"

# Get absolute path of project root
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Extend PATH with the custom cross-compilers
export PATH="$PROJECT_ROOT/.toolchains/aarch64-linux-musl-cross/bin:$PATH"

echo "=== Building Linux x86_64 (Release with rsigma-engine) ==="
cargo build --release --target x86_64-unknown-linux-gnu --features rsigma-engine

echo "=== Building Linux arm64 (Release with rsigma-engine) ==="
export CARGO_TARGET_AARCH64_UNKNOWN_LINUX_MUSL_LINKER=aarch64-linux-musl-gcc
cargo build --release --target aarch64-unknown-linux-musl --features rsigma-engine

echo "=== Building Windows x86_64 (Release with rsigma-engine) ==="
export CARGO_TARGET_X86_64_PC_WINDOWS_GNU_LINKER=x86_64-w64-mingw32-gcc
cargo build --release --target x86_64-pc-windows-gnu --features rsigma-engine

echo "=== Packaging Artifacts ==="
VERSION=$(grep -m1 "^version\s*=" "$PROJECT_ROOT/Cargo.toml" | cut -d'"' -f2)
RELEASE_DIR="$PROJECT_ROOT/release/${VERSION}r${RADEGAST_PATCH_VERSION}"
mkdir -p "$RELEASE_DIR"

zip_file() {
    local src="$1"
    local dest="$2"
    local arcname="$3"
    python3 -c "import zipfile, sys; z = zipfile.ZipFile(sys.argv[2], 'w', zipfile.ZIP_DEFLATED); z.write(sys.argv[1], arcname=sys.argv[3]); z.close()" "$src" "$dest" "$arcname"
}

echo "Packaging Linux x86_64..."
zip_file "$PROJECT_ROOT/target/x86_64-unknown-linux-gnu/release/rustinel" "$RELEASE_DIR/linux-amd64.zip" "rustinel"

echo "Packaging Linux arm64..."
zip_file "$PROJECT_ROOT/target/aarch64-unknown-linux-musl/release/rustinel" "$RELEASE_DIR/linux-arm64.zip" "rustinel"

echo "Packaging Windows x86_64..."
zip_file "$PROJECT_ROOT/target/x86_64-pc-windows-gnu/release/rustinel.exe" "$RELEASE_DIR/windows-amd64.zip" "rustinel.exe"

echo "=== Build and Packaging Complete ==="
echo "Artifacts zipped to $RELEASE_DIR/:"
echo "  - Linux x86_64:  linux-amd64.zip"
echo "  - Linux arm64:   linux-arm64.zip"
echo "  - Windows:       windows-amd64.zip"
