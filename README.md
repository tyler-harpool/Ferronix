# Ferronix

A robust Rust application with a reproducible development environment using Nix and direnv. Ferronix combines the power of Rust (ferrous/iron) with Nix for a reliable, consistent development experience.

## Prerequisites

- [Nix with Flakes enabled](https://nixos.org/download.html) (for the reproducible development environment)
- [direnv](https://direnv.net/) for automatic environment loading

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

You'll see a fun welcome message from cowsay when the environment activates:

3. Build the application:

```bash
cargo build
```

4. Run the application:

```bash
cargo run
```

## Project Structure

- `src/main.rs`: The main entry point for the application
- `Cargo.toml`: Project configuration and dependencies
- `flake.nix`: Nix Flake configuration for reproducible development environment
- `shell.nix`: Alternative Nix configuration for non-flake users
- `.envrc`: direnv configuration for automatic environment loading
- `welcome.sh`: Script to display the cowsay welcome message on demand

## Features

The development environment includes:

- Rust toolchain with rust-src, rust-analyzer, clippy, and rustfmt
- Cargo tools: cargo-audit, cargo-watch, cargo-expand
- OpenSSL and pkg-config for building dependencies
- Cowsay for a fun welcome message

## License

This project is open source and available under the [MIT License](LICENSE).