#!/bin/bash

# Check if wasm-pack is installed
if ! command -v wasm-pack &> /dev/null; then
    echo "wasm-pack not found. Please install it first."
    exit 1
fi

# Build the WebAssembly module
echo "Building WebAssembly module..."
wasm-pack build --target web

# Start a simple HTTP server
echo "Starting HTTP server on http://localhost:8000"
echo "Press Ctrl+C to stop the server"
cd .. && python -m http.server 8000