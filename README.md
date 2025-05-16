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

## Release Process

Ferronix uses GitHub Actions to automatically build binaries for multiple platforms when you create a new tag:

```bash
# Update version in Cargo.toml first
git tag -a v0.1.0 -m "Release v0.1.0"
git push origin v0.1.0
```

This will build and publish binaries for:
- Linux x86_64
- macOS x86_64 (Intel)
- macOS ARM64 (Apple Silicon)
- Windows x86_64

See [VERSIONING.md](VERSIONING.md) for more details.

## License

This project is open source and available under the [MIT License](LICENSE)