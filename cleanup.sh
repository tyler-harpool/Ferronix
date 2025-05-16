#!/bin/bash

# Cleanup script to remove container-related files and keep only Nix for Rust environment

echo "Cleaning up container-related files..."

# Remove Docker files
rm -f Dockerfile Dockerfile.minimal Dockerfile.nix Dockerfile.simple

# Remove container setup scripts
rm -f build-mitchell.sh build-nix-docker.sh build.sh check-docker.sh 
rm -f debug-rancher.sh docker-compose.yml ferronix-lima.yaml
rm -f mitchell-approach.md nix-container-benefits.md
rm -f quick-setup-rancher.sh setup-rancher.sh run-app.sh
rm -f RANCHER-QUICKSTART.md

echo "Done! Your project now focuses only on using Nix for Rust development."
echo "You can use the following commands for development:"
echo "  - nix develop    # Enter the development environment"
echo "  - cargo build    # Build the Rust application"
echo "  - cargo run      # Run the Rust application"
echo "  - ./welcome.sh   # Display the welcome message"