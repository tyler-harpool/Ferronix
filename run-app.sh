#!/usr/bin/env bash
# run-app.sh - Run Ferronix directly without containers

# Set script to exit on error
set -e

# Directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR"

# Colors for better output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}====================================================${NC}"
echo -e "${BLUE}    Ferronix - Running Directly with Nix    ${NC}"
echo -e "${GREEN}====================================================${NC}"

# Function to run the app with nix-shell
run_with_nix() {
  echo -e "${YELLOW}Starting Ferronix in Nix environment...${NC}"
  
  # Use nix develop or nix-shell depending on what's available
  if command -v nix &> /dev/null; then
    nix develop --command bash -c "
      echo 'Running in Nix develop shell'
      # Default is to run the main application
      cargo run -- \"\$@\"
    "
  else
    echo "Nix not found. Please install Nix first."
    exit 1
  fi
}

# Function to display environment info
show_environment() {
  echo -e "${YELLOW}Environment Information:${NC}"
  nix develop --command bash -c "
    echo 'Rust: $(rustc --version)'
    echo 'Cargo: $(cargo --version)'
    echo 'Node.js: $(node --version 2>/dev/null || echo \"Not installed\")'
    echo 'npm: $(npm --version 2>/dev/null || echo \"Not installed\")'
  "
}

# Help message
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  echo "Usage: ./run-app.sh [OPTION]"
  echo ""
  echo "Options:"
  echo "  -h, --help      Show this help message"
  echo "  -e, --env       Show environment information"
  echo "  -b, --build     Build the application without running"
  echo "  --release       Run in release mode"
  echo ""
  echo "Without options, runs the application in development mode."
  exit 0
fi

# Handle different options
if [ "$1" == "-e" ] || [ "$1" == "--env" ]; then
  show_environment
elif [ "$1" == "-b" ] || [ "$1" == "--build" ]; then
  nix develop --command bash -c "cargo build"
  echo -e "${GREEN}Build complete.${NC}"
elif [ "$1" == "--release" ]; then
  shift
  nix develop --command bash -c "cargo run --release -- $@"
else
  run_with_nix "$@"
fi