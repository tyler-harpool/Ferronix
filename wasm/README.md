# Ferronix WebAssembly Module

This directory contains a WebAssembly module that provides browser-compatible bindings for Ferronix functionality.

## Prerequisites

Make sure you have the following tools installed:

- Rust with `wasm32-unknown-unknown` target
- wasm-pack
- Node.js and npm (for testing)

These are all included in the Nix development environment.

## Building the WebAssembly Module

To build the WebAssembly module, run:

```bash
# Build with wasm-pack targeting the web
cd wasm
wasm-pack build --target web

# Or for Node.js environments:
wasm-pack build --target nodejs
```

This will generate a `pkg` directory containing the compiled WebAssembly module and JavaScript bindings.

## Testing in a Browser

After building, you can test the WebAssembly module using the provided HTML file and server script:

```bash
# Use the provided convenience script
cd wasm
./serve.sh
```

This will:
1. Build the WebAssembly module with wasm-pack
2. Start a Python HTTP server on port 8000
3. Serve the files from the project root

Then open your browser and navigate to `http://localhost:8000/wasm/index.html` to see the demo.

If you prefer to do it manually:

```bash
# Build the module
cd wasm
wasm-pack build --target web

# Go back to project root and start HTTP server
cd ..
python -m http.server 8000
```

## Usage in JavaScript/TypeScript

```javascript
import init, { add, greet, process_data } from './pkg/ferronix_wasm.js';

async function run() {
  // Initialize the WebAssembly module
  await init();
  
  // Use functions from the module
  const sum = add(5, 7);  // 12
  const greeting = greet("World");  // "Hello, World! Welcome to Ferronix WASM!"
  
  // Process an array
  const result = process_data([1, 2, 3, 4, 5]);
  console.log(`Sum: ${result[0]}, Count: ${result[1]}`);  // Sum: 15, Count: 5
}

run();
```

## API Reference

### `add(a: number, b: number): number`

Adds two numbers together and returns the result.

### `greet(name: string): string`

Returns a greeting message with the provided name.

### `process_data(data: number[]): [number, number]`

Processes an array of numbers and returns a tuple containing:
1. The sum of all numbers
2. The count of numbers in the array