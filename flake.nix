{
  description = "Ferronix - A robust Rust application with Nix integration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rust-analyzer" "clippy" "rustfmt" ];
        };
        
        # Build the Rust application
        ferronixBin = pkgs.rustPlatform.buildRustPackage {
          pname = "ferronix";
          version = "0.1.0";
          src = ./.;
          
          # More flexible way to handle cargo lock
          cargoLock = {
            lockFilePath = ./Cargo.lock;
            outputHashes = {};
          };
          
          buildInputs = [ pkgs.openssl.dev ];
          nativeBuildInputs = [ pkgs.pkg-config ];
        };

      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rustToolchain

            # Additional tools
            pkg-config
            openssl
            openssl.dev
            cowsay
            git
            nodejs_20
            nodePackages.npm
            
            # Development tools
            cargo-audit
            cargo-watch
            cargo-expand
          ];

          shellHook = ''
            # Set up environment variables
            export RUST_BACKTRACE=1
            export RUSTFLAGS="-C target-cpu=native"
            
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
              echo "Claude Code installed successfully!"
            fi
            
            # Install aicommits if it's not already installed
            if ! command -v aicommits &> /dev/null; then
              echo "Installing aicommits globally..."
              npm install -g aicommits
              echo "AI Commits installed successfully!"
            fi
            
            # Welcome message with cowsay
            ${pkgs.cowsay}/bin/cowsay "Welcome to Ferronix - Rust powered by NIX"
            echo "🦀 Ferronix development environment activated!"
            echo "🔧 Rust toolchain: $(rustc --version)"
            echo "📦 Cargo: $(cargo --version)"
            echo "🟢 Node.js: $(node --version)"
            echo "📦 npm: $(npm --version)"
            echo "🤖 AI Tools: claude-code, aicommits"
            echo ""
          '';

          # Environment variables for specific libraries
          OPENSSL_DIR = "${pkgs.openssl.dev}";
          OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
        };
        
        # Default package is the Rust binary
        packages.default = ferronixBin;
        
        # Default app
        apps.default = flake-utils.lib.mkApp {
          drv = ferronixBin;
        };
      }
    );
}
