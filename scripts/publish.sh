#!/bin/bash
set -euo pipefail

# Publishes all packages to npm
# Usage: ./scripts/publish.sh <version>
# Example: ./scripts/publish.sh 0.3.5
#
# Prerequisites:
# - npm login (or NPM_TOKEN environment variable)
# - Binaries downloaded via ./scripts/download-binaries.sh

if [ -z "${1:-}" ]; then
  echo "Usage: $0 <version>"
  echo "Example: $0 0.3.5"
  exit 1
fi

VERSION="${1#v}"  # Strip 'v' prefix if present
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo "Publishing Haloy v${VERSION} to npm..."

# Verify binaries exist
PLATFORMS=(
  "cli-darwin-arm64:haloy"
  "cli-darwin-x64:haloy"
  "cli-linux-arm64:haloy"
  "cli-linux-x64:haloy"
  "cli-win32-arm64:haloy.exe"
  "cli-win32-x64:haloy.exe"
)

echo "Checking binaries..."
for platform in "${PLATFORMS[@]}"; do
  IFS=':' read -r pkg bin <<< "$platform"
  bin_path="${ROOT_DIR}/packages/${pkg}/bin/${bin}"
  if [ ! -f "$bin_path" ] || [ ! -s "$bin_path" ]; then
    echo "Error: Binary not found or empty: $bin_path"
    echo "Run ./scripts/download-binaries.sh ${VERSION} first"
    exit 1
  fi
done
echo "All binaries present."

# Update versions in all package.json files
echo "Updating package versions to ${VERSION}..."
for pkg in "${ROOT_DIR}"/packages/*/package.json; do
  jq --arg v "$VERSION" '.version = $v' "$pkg" > tmp.json && mv tmp.json "$pkg"
done

# Update optionalDependencies in main package
jq --arg v "$VERSION" '
  .optionalDependencies |= with_entries(.value = $v)
' "${ROOT_DIR}/packages/haloy/package.json" > tmp.json && mv tmp.json "${ROOT_DIR}/packages/haloy/package.json"

# Publish platform packages first
echo "Publishing platform packages..."
for platform in "${PLATFORMS[@]}"; do
  IFS=':' read -r pkg _ <<< "$platform"
  echo "  -> @haloydev/${pkg}"
  cd "${ROOT_DIR}/packages/${pkg}"
  npm publish --access public --tag latest
  cd "${ROOT_DIR}"
done

# Publish main package
echo "Publishing main package..."
cd "${ROOT_DIR}/packages/haloy"
npm publish --access public --tag latest
cd "${ROOT_DIR}"

echo "Done! Published haloy@${VERSION} and all platform packages."
