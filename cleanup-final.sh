#!/bin/bash

# Comprehensive cleanup script for Ferronix
# Simplifies the project to focus only on Nix Flakes for Rust development

echo "Performing comprehensive cleanup of Ferronix project..."

# Remove any remaining container-related files
echo "Removing container-related files..."
rm -f Dockerfile* docker-compose.yml ferronix-lima.yaml
rm -f *docker*.sh *rancher*.sh build*.sh
rm -f RANCHER-QUICKSTART.md mitchell-approach.md nix-container-benefits.md

# Remove traditional Nix files (we're focusing on flakes)
echo "Removing traditional Nix files..."
rm -f default.nix shell.nix

# Remove extra files
echo "Removing unnecessary files..."
rm -f run-app.sh welcome.sh

# Optional: remove Node.js artifacts as they're managed by Nix
# Uncomment these lines if you want to remove the package.json files
# Note: The AI tools will still work as they are installed globally by Nix
echo "Removing Node.js artifacts (tools will still work via Nix)..."
rm -f package.json package-lock.json

echo ""
echo "Cleanup complete! Your project now focuses exclusively on Rust with Nix Flakes."
echo ""
echo "Remaining essential files:"
echo "- src/         (Rust source code)"
echo "- Cargo.toml   (Rust package configuration)"
echo "- Cargo.lock   (Locked dependencies for reproducible builds)"
echo "- flake.nix    (Nix Flake configuration)"
echo "- flake.lock   (Locked Nix dependencies for reproducible environments)"
echo "- .envrc       (direnv configuration)"
echo "- rust-analyzer.toml (IDE configuration)"
echo "- README.md    (Project documentation)"
echo ""
echo "Development workflow:"
echo "1. nix develop  (Enter development environment)"
echo "2. cargo build  (Build the application)"
echo "3. cargo run    (Run the application)"
echo ""
echo "These commands work because of the environment defined in flake.nix"