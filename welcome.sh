#!/bin/bash

# Ferronix welcome script with cowsay

# Function to display welcome message
show_welcome() {
  echo ""
  echo " ==============================================="
  echo "  Welcome to Ferronix - Rust powered by NIX"
  echo " ==============================================="
  echo ""
  
  # Try using cowsay if it exists
  if command -v cowsay &>/dev/null; then
    cowsay "Welcome to Ferronix - Rust powered by NIX"
  fi
  
  # Show Rust information if available
  if command -v rustc &>/dev/null; then
    echo "🦀 Rust toolchain: $(rustc --version)"
  else
    echo "🦀 Rust toolchain: Not found"
  fi
  
  if command -v cargo &>/dev/null; then
    echo "📦 Cargo: $(cargo --version)"
  else
    echo "📦 Cargo: Not found"
  fi
  
  echo ""
}

# Call the function
show_welcome