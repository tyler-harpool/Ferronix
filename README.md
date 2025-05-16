# Ferronix

A streamlined Rust application with a reproducible development environment using Nix Flakes. Ferronix combines the power of Rust (ferrous/iron) with Nix for a reliable, consistent, and reproducible development experience across platforms.

## Why Nix Flakes for Rust Development?

### The Nix Approach

[Nix](https://nixos.org/) is a powerful package manager that enables:
- **Reproducible builds**: Identical environments every time
- **Hermetic packaging**: Isolated development environments with precise dependencies
- **Cross-platform consistency**: Works on Linux, macOS, and WSL

### Nix Flakes vs Traditional Nix

Flakes are a more modern, improved approach to Nix:

- **Reproducibility**: Flakes use lockfiles (`flake.lock`) to pin exact versions of every dependency
- **Portability**: Work seamlessly across different machines with the same results
- **Simplified interfaces**: Clear, consistent commands (`nix develop`, `nix build`)
- **Isolated environments**: Each project has its own contained dependencies
- **Faster development cycles**: Better caching of dependencies
- **IDE integration**: Better support for VS Code, Vim, and other editors

Traditional Nix requires `shell.nix` files and uses `nix-shell`, making it less deterministic and more complex to configure. Flakes provide a standardized structure that eliminates many edge cases.

## Prerequisites

- [Nix with Flakes enabled](https://nixos.org/download.html)
- (Optional) [direnv](https://direnv.net/) for automatic environment loading

## Getting Started

1. Clone this repository
2. Enter the development environment:

```bash
# Using Nix directly
nix develop

# Or, with direnv (recommended)
cd ferronix
direnv allow  # Only needed first time or after .envrc changes
```

3. Build and run the application:

```bash
# Build
cargo build

# Run
cargo run
```

## Project Structure

- `src/main.rs` - Main Rust application
- `Cargo.toml` - Rust package configuration
- `flake.nix` - Nix Flake definition (the core of our reproducible environment)
- `.envrc` - direnv configuration for automatic environment loading

## Development Environment Features

- **Rust toolchain**: Complete toolchain with rust-analyzer, clippy, and rustfmt
- **Development tools**: cargo-audit, cargo-watch, cargo-expand
- **Dependencies**: OpenSSL and pkg-config preconfigured
- **AI assistance**: Node.js and npm with claude-code and aicommits for AI assistance
- **Binary caching**: [Cachix](https://cachix.org/) integration for faster builds ([setup guide](CACHIX-SETUP.md))

## Release Process

Ferronix uses GitHub Actions for automated cross-platform releases with a streamlined process.

### Automated Releases

When you update the version in `Cargo.toml` and merge to the main branch:

1. Update the version in `Cargo.toml` (e.g., `version = "0.1.9"`)
2. Commit and merge your changes to the main branch
3. The `auto-release.yml` workflow automatically:
   - Detects the version change
   - Creates a git tag (e.g., `v0.1.9`)
   - Triggers the platform-specific build workflows

### Manual Releases

You can trigger releases in three ways:

1. **Direct tag creation**:
   ```bash
   git tag -a v0.1.0 -m "Release v0.1.0"
   git push origin v0.1.0
   ```

2. **Using the GitHub UI**:
   - Go to Actions → "Automatic Release" workflow
   - Click "Run workflow"
   - Enter the version number (without "v" prefix)
   - Click "Run workflow"

3. **Creating a GitHub Release directly**:
   - Go to Releases → "Draft new release"
   - Create a new tag (must be in format `v*.*.*`)
   - Publish the release

### Required Secrets

For the automated release process to work properly, the repository needs:

- `PAT_TOKEN`: A Personal Access Token with "workflow" permission
  - This allows the release workflow to trigger other workflows
  - Without this, GitHub prevents workflows from triggering other workflows

- `CACHIX_AUTH_TOKEN`: For Cachix integration to speed up builds

### Build Outputs

Each release automatically builds binaries for:
- Linux x86_64
- macOS x86_64 (Intel)
- macOS ARM64 (Apple Silicon)
- Windows x86_64

These are published to the GitHub release page as downloadable assets.

## Run OSX

We don't sign the OSX binary, so OSX will complain that it can't verify the signature. First, review the code to ensure that nothing sketch is going on. Second, you can run these commands:

- xattr -dr com.apple.quarantine ferronix-macos-arm64
- ./ferronix-macos-arm64

You should see something like this:
```
Hello, World!

JSON data:
{
  "message": "Hello, World!",
  "timestamp": "2025-05-16T16:58:10.005621+00:00"
}
2025-05-16T16:58:10.005626Z  INFO ferronix: Application completed successfully
```

See [VERSIONING.md](VERSIONING.md) for more details.

## License

This project is open source and available under the [MIT License](LICENSE)
