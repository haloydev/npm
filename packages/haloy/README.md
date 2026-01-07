# Haloy

Simple deployment tool for Docker-based applications.

## Installation

```bash
npm install -g haloy
```

Or use with npx:

```bash
npx haloy version
```

## Usage

```bash
haloy [command] [flags]
```

### Commands

- `haloy init` - Initialize a new Haloy configuration
- `haloy deploy` - Deploy your application
- `haloy version` - Show version information

For full documentation, visit [haloy.dev](https://haloy.dev).

## Programmatic API

You can also use Haloy programmatically:

```javascript
const haloy = require("haloy");

// Get path to the binary
const binPath = haloy.getBinaryPath();

// Execute synchronously
const output = haloy.execSync(["version"]);
console.log(output.toString());

// Execute asynchronously
const child = haloy.exec(["deploy"], { stdio: "inherit" });
child.on("close", (code) => {
  console.log(`Process exited with code ${code}`);
});
```

## Supported Platforms

- macOS (ARM64, x64)
- Linux (ARM64, x64)
- Windows (ARM64, x64)

## License

MIT
