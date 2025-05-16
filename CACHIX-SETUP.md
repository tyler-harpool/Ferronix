# Cachix Setup for Ferronix

This guide explains how to set up [Cachix](https://cachix.org/) for Ferronix to speed up builds and improve CI/CD reliability.

## What is Cachix?

Cachix is a binary cache for Nix. It stores the results of Nix builds so they don't have to be rebuilt from scratch each time, significantly speeding up builds in CI and for developers.

## Benefits for Ferronix

1. **Faster CI/CD**: Builds are much faster since dependencies don't need to be rebuilt each time
2. **Consistent Environments**: Everyone uses the exact same binaries across CI and development
3. **Reduced Resource Usage**: Less CPU and memory needed for builds
4. **Reliable Releases**: Release builds can reuse CI-built components

## Setup Instructions

### 1. Create a Cachix Cache

1. Go to [cachix.org](https://cachix.org/) and sign up/login
2. Create a new cache named `ferronix`
3. Follow the instructions to set up your local environment

### 2. Generate Auth Token

1. In your Cachix dashboard, go to "Auth tokens"
2. Generate a new token with write access to your `ferronix` cache
3. Copy the token - you'll need it for GitHub

### 3. Set Up GitHub Secret

1. Go to your GitHub repository, click "Settings" > "Secrets" > "Actions"
2. Click "New repository secret"
3. Name: `CACHIX_AUTH_TOKEN`
4. Value: Paste the token you copied
5. Click "Add secret"

### 4. Using Cachix Locally

To use the cache locally:

```bash
# Install Cachix
nix-env -iA cachix -f https://cachix.org/api/v1/install

# Authenticate (only needed once)
cachix authtoken <your-token>

# Use the Ferronix cache
cachix use ferronix
```

Or with flakes:

```bash
# Install with flakes
nix profile install nixpkgs#cachix

# Authenticate and use cache
cachix authtoken <your-token>
cachix use ferronix
```

## Verifying Setup

Once set up, you'll notice:

1. GitHub Actions builds are faster (observable in workflow logs)
2. The "Setup Cachix" step in workflows shows cache hits
3. Local builds are faster after enabling the cache

## Troubleshooting

If your GitHub Actions aren't pushing to Cachix:
- Ensure the `CACHIX_AUTH_TOKEN` secret is correctly set
- Check the "pushFilter" setting in the workflow yaml
- Verify write permissions are correct for your token

If your local builds aren't using the cache:
- Check that you ran `cachix use ferronix`
- Verify that `substituters` and `trusted-public-keys` are in your Nix config