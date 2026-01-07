#!/bin/bash
set -euo pipefail

# Downloads binaries from GitHub release for local testing
# Usage: ./scripts/download-binaries.sh <version>
# Example: ./scripts/download-binaries.sh 0.3.5

if [ -z "${1:-}" ]; then
  echo "Usage: $0 <version>"
  echo "Example: $0 0.3.5"
  exit 1
fi

VERSION="${1#v}"  # Strip 'v' prefix if present
BASE_URL="https://github.com/haloydev/haloy/releases/download/v${VERSION}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo "Downloading Haloy v${VERSION} binaries..."

# Darwin ARM64
echo "  -> darwin-arm64"
curl -sL "${BASE_URL}/haloy-darwin-arm64" -o "${ROOT_DIR}/packages/cli-darwin-arm64/bin/haloy"
chmod +x "${ROOT_DIR}/packages/cli-darwin-arm64/bin/haloy"

# Darwin x64
echo "  -> darwin-x64"
curl -sL "${BASE_URL}/haloy-darwin-amd64" -o "${ROOT_DIR}/packages/cli-darwin-x64/bin/haloy"
chmod +x "${ROOT_DIR}/packages/cli-darwin-x64/bin/haloy"

# Linux ARM64
echo "  -> linux-arm64"
curl -sL "${BASE_URL}/haloy-linux-arm64" -o "${ROOT_DIR}/packages/cli-linux-arm64/bin/haloy"
chmod +x "${ROOT_DIR}/packages/cli-linux-arm64/bin/haloy"

# Linux x64
echo "  -> linux-x64"
curl -sL "${BASE_URL}/haloy-linux-amd64" -o "${ROOT_DIR}/packages/cli-linux-x64/bin/haloy"
chmod +x "${ROOT_DIR}/packages/cli-linux-x64/bin/haloy"

# Windows ARM64
echo "  -> win32-arm64"
curl -sL "${BASE_URL}/haloy-windows-arm64.exe" -o "${ROOT_DIR}/packages/cli-win32-arm64/bin/haloy.exe"

# Windows x64
echo "  -> win32-x64"
curl -sL "${BASE_URL}/haloy-windows-amd64.exe" -o "${ROOT_DIR}/packages/cli-win32-x64/bin/haloy.exe"

echo "Done! All binaries downloaded to packages/*/bin/"
