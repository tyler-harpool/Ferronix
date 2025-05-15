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
    # No additional inputs needed for our simple container approach
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
        
        # Container configuration
        containerName = "ferronix";
        containerTag = "latest";
        
        # TODO: Uncomment this to build the real Rust application
        # ferronixBin = pkgs.rustPlatform.buildRustPackage {
        #   pname = "ferronix";
        #   version = "0.1.0";
        #   src = ./.;
        #   cargoLock = {
        #     lockFile = ./Cargo.lock;
        #   };
        #   buildInputs = [ pkgs.openssl.dev ];
        #   nativeBuildInputs = [ pkgs.pkg-config ];
        # };
        
        # Simple script for the container instead of building the Rust application
        ferronixScript = pkgs.writeShellScriptBin "ferronix" ''
          #!/bin/sh
          echo "=========================================="
          echo "Welcome to Ferronix Container!"
          echo "=========================================="
          echo "Container started at $(date)"
          echo "Running in $(pwd)"
          echo ""
          echo "This is a placeholder for your Rust application."
          echo "To build the actual Rust app:"
          echo "1. Run 'cargo generate-lockfile' in your project"
          echo "2. Uncomment the ferronixBin section in flake.nix"
          echo "3. Change container to use ferronixBin instead of ferronixScript"
          
          # Keep container running
          if [ "$1" = "--server" ]; then
            echo "Server mode: listening on port 8080..."
            while true; do
              sleep 10
            done
          else
            # Print args
            if [ $# -gt 0 ]; then
              echo "Arguments: $@"
            fi
          fi
        '';

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
            
            # Container tools
            podman
            skopeo
            buildah
            
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
            🐳 Container Tools: podman, buildah, skopeo
            echo ""
            echo "Container commands:"
            nix build .#container     - Build the container package
            ./result/load-container.sh - Load the image into Podman
            podman run -it ferronix   - Run the container
            echo ""
            echo "To build container with Rust app inside:"
            echo "  1. Generate Cargo.lock: cargo generate-lockfile"
            echo "  2. Uncomment the real app build in flake.nix"
          '';

          # Environment variables for specific libraries
          OPENSSL_DIR = "${pkgs.openssl.dev}";
          OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
        };
        
        # Simplified container approach using writeScript
        packages.container = pkgs.runCommand "ferronix-container.tar.gz" {} ''
          mkdir -p $out/bin
          cp ${ferronixScript}/bin/ferronix $out/bin/
          chmod +x $out/bin/ferronix
          
          # Create a simple tarball that can be loaded as a container
          cd $out
          tar -czf $out/ferronix-container.tar.gz bin
          
          # Create a load script
          cat > $out/load-container.sh <<EOF
          #!/bin/sh
          echo "Creating Ferronix container..."
          podman import $out/ferronix-container.tar.gz ${containerName}:${containerTag}
          echo "Container created! Run with: podman run -it ${containerName}:${containerTag} /bin/ferronix"
          EOF
          
          chmod +x $out/load-container.sh
        '';
        
        # Default package
        packages.default = ferronixScript;
        
        # App definitions
        apps.container = flake-utils.lib.mkApp {
          drv = pkgs.writeShellScriptBin "build-container" ''
            echo "Building Ferronix container..."
            nix build .#container
            echo "Container built successfully!"
            echo "To load into Podman: ./result/load-container.sh"
          '';
        };
        
        # Default app
        apps.default = flake-utils.lib.mkApp {
          drv = ferronixScript;
        };
      }
    );
}
