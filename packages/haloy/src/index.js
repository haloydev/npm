/**
 * Haloy - Simple deployment tool for Docker-based applications
 *
 * This module provides programmatic access to the haloy CLI.
 */

const { spawn, execFileSync } = require("child_process");
const path = require("path");
const fs = require("fs");

const PLATFORMS = {
  "darwin-arm64": "@haloydev/cli-darwin-arm64",
  "darwin-x64": "@haloydev/cli-darwin-x64",
  "linux-arm64": "@haloydev/cli-linux-arm64",
  "linux-x64": "@haloydev/cli-linux-x64",
  "win32-arm64": "@haloydev/cli-win32-arm64",
  "win32-x64": "@haloydev/cli-win32-x64",
};

/**
 * Get the path to the haloy binary for the current platform.
 * @returns {string} Path to the haloy binary
 * @throws {Error} If the binary is not found or platform is unsupported
 */
function getBinaryPath() {
  const platformKey = `${process.platform}-${process.arch}`;
  const pkg = PLATFORMS[platformKey];

  if (!pkg) {
    throw new Error(
      `Unsupported platform: ${platformKey}. Supported platforms: ${Object.keys(PLATFORMS).join(", ")}`
    );
  }

  try {
    const pkgPath = require.resolve(`${pkg}/package.json`);
    const pkgDir = path.dirname(pkgPath);
    const binName = process.platform === "win32" ? "haloy.exe" : "haloy";
    const binPath = path.join(pkgDir, "bin", binName);

    if (!fs.existsSync(binPath)) {
      throw new Error(`Binary not found at ${binPath}`);
    }

    return binPath;
  } catch (e) {
    throw new Error(
      `Could not find haloy binary for ${platformKey}. Package ${pkg} may not be installed. Try reinstalling: npm install haloy`
    );
  }
}

/**
 * Execute haloy synchronously with the given arguments.
 * @param {string[]} args - Command line arguments
 * @param {object} [options] - Options passed to execFileSync
 * @returns {Buffer|string} Command output
 */
function execSync(args, options = {}) {
  const binPath = getBinaryPath();
  return execFileSync(binPath, args, options);
}

/**
 * Execute haloy asynchronously with the given arguments.
 * @param {string[]} args - Command line arguments
 * @param {object} [options] - Options passed to spawn
 * @returns {ChildProcess} The spawned child process
 */
function exec(args, options = {}) {
  const binPath = getBinaryPath();
  return spawn(binPath, args, options);
}

module.exports = {
  getBinaryPath,
  execSync,
  exec,
  PLATFORMS,
};
