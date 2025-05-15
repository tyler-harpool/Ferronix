{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Core tools only for fast loading
    rustc
    cargo

    # Essential dependencies
    pkg-config
    openssl
    git
    nodejs_20
    nodePackages.npm
  ];

  # Environment variables
  RUST_BACKTRACE = "1";
  RUSTFLAGS = "-C target-cpu=native";
  OPENSSL_DIR = "${pkgs.openssl.dev}";
  OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";

  # Simple hooks that execute quickly
  shellHook = ''
    # Display a simple welcome message
    echo ""
    echo "=================================================="
    echo "Welcome to Ferronix - Rust powered by NIX"
    echo "=================================================="
    echo "Rust: $(rustc --version 2>/dev/null || echo 'not found')"
    echo "Cargo: $(cargo --version 2>/dev/null || echo 'not found')"
    echo "Node.js: $(node --version 2>/dev/null || echo 'not found')"
    echo "npm: $(npm --version 2>/dev/null || echo 'not found')"
    echo "AI Tools: claude-code, aicommits"
    echo ""
    
    # Set up npm global packages without requiring sudo
    export NPM_CONFIG_PREFIX=$HOME/.npm-global
    export PATH=$HOME/.npm-global/bin:$PATH
    mkdir -p $HOME/.npm-global
    
    # Update npm to latest version
    echo "Updating npm to latest version..."
    npm install -g npm@latest
    
    # Install claude-code if it's not already installed
    if ! command -v claude-code &> /dev/null; then
      echo "Installing @anthropic-ai/claude-code globally..."
      npm install -g @anthropic-ai/claude-code
    fi
    
    # Install aicommits if it's not already installed
    if ! command -v aicommits &> /dev/null; then
      echo "Installing aicommits globally..."
      npm install -g aicommits
    fi
    
    # You can run './welcome.sh' for the cowsay welcome
  '';
}