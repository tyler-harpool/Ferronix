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
        
        # For development environments, prefer to use Cargo directly
        # This simplified approach is better for dev environments
        ferronixScript = pkgs.writeShellScriptBin "ferronix" ''
          #!/bin/sh
          # Print args
          if [ $# -gt 0 ]; then
            echo "Running with arguments: $@"
            cargo run -- "$@"
          else
            cargo run
          fi
        '';
          
        # Full Nix package - disabled for now to simplify development
        # Uncomment when ready for proper packaging
        # ferronixBin = pkgs.rustPlatform.buildRustPackage {
        #   pname = "ferronix";
        #   version = "0.1.0";
        #   src = ./.;
        #   doCheck = false;
        #   cargoLock.lockFile = ./Cargo.lock;
        #   buildInputs = [ pkgs.openssl.dev ];
        #   nativeBuildInputs = [ pkgs.pkg-config ];
        # };

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
            
            # Use pinned npm version
            echo "Using pinned npm version..."
            # Only install if the correct version isn't already installed
            if [ "$(npm --version)" != "11.4.0" ]; then
              npm install -g npm@11.4.0
            fi
            
            # Install claude-code if it's not already installed
            if ! command -v claude-code &> /dev/null; then
              echo "Installing @anthropic-ai/claude-code@0.2.113 globally..."
              npm install -g @anthropic-ai/claude-code@0.2.113
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
        
        # Default package is the simple script wrapper
        packages.default = ferronixScript;
        
        # Default app
        apps.default = flake-utils.lib.mkApp {
          drv = ferronixScript;
        };
      }
    );
}
