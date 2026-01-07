# haloy-npm

npm distribution for [Haloy](https://github.com/haloydev/haloy), a simple deployment tool for Docker-based applications.

This repository contains the npm packages that wrap the pre-built Go binaries using the platform-specific optional dependencies pattern.

## Packages

| Package | Description |
|---------|-------------|
| `haloy` | Main user-facing package with JS wrapper |
| `@haloydev/cli-darwin-arm64` | macOS Apple Silicon binary |
| `@haloydev/cli-darwin-x64` | macOS Intel binary |
| `@haloydev/cli-linux-arm64` | Linux ARM64 binary |
| `@haloydev/cli-linux-x64` | Linux x64 binary |
| `@haloydev/cli-win32-arm64` | Windows ARM64 binary |
| `@haloydev/cli-win32-x64` | Windows x64 binary |

## How It Works

The main `haloy` package declares all platform-specific packages as optional dependencies. When installed, npm will only download the binary for the current platform due to the `os` and `cpu` fields in each platform package.

The JS wrapper in `haloy` detects the current platform and executes the appropriate binary.

## Development

### Prerequisites

- Node.js 16+
- pnpm 9+

### Local Testing

1. Download binaries for a specific version:

```bash
./scripts/download-binaries.sh 0.3.5
```

2. Install dependencies:

```bash
pnpm install
```

3. Test the CLI:

```bash
node packages/haloy/bin/haloy version
```

### Publishing

Publishing is automated via GitHub Actions. When the main [haloydev/haloy](https://github.com/haloydev/haloy) repository creates a new release, it triggers the publish workflow in this repository via `repository_dispatch`.

For manual publishing:

```bash
./scripts/download-binaries.sh <version>
./scripts/publish.sh <version>
```

## Setup Checklist (for new repositories)

1. **npm organization**: Create `haloydev` org at https://www.npmjs.com/org/create
2. **Package names**: Verify `haloy` (unscoped) is available
3. **npm token**: Generate automation token at npm with publish access
4. **GitHub secrets**:
   - `haloydev/haloy`: Add `HALOY_NPM_DISPATCH_TOKEN` (GitHub PAT with repo scope)
   - `haloydev/haloy-npm`: Add `NPM_TOKEN` (npm automation token)
5. **Main repo CI**: Add repository_dispatch step to release workflow:

```yaml
- name: Trigger npm publish
  uses: peter-evans/repository-dispatch@v3
  with:
    token: ${{ secrets.HALOY_NPM_DISPATCH_TOKEN }}
    repository: haloydev/haloy-npm
    event-type: release
    client-payload: '{"version": "${{ github.ref_name }}"}'
```

## License

MIT
