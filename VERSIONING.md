# Versioning Guide for Ferronix

Ferronix follows [Semantic Versioning](https://semver.org/) (SemVer) for release management.

## Version Format

Versions follow the format `MAJOR.MINOR.PATCH`:

- **MAJOR** version increases for incompatible API changes
- **MINOR** version increases for backward-compatible functionality additions
- **PATCH** version increases for backward-compatible bug fixes

## Release Process

### 1. Update Version Numbers

Before creating a release, update version numbers in:
- `Cargo.toml`
- `flake.nix` (the `version` field in `ferronixBin`)

### 2. Create a Git Tag

```bash
# For version 0.1.0
git tag -a v0.1.0 -m "Release v0.1.0"
git push origin v0.1.0
```

### 3. GitHub Actions Release Workflow

Pushing a tag that matches the pattern `v*.*.*` will trigger the GitHub Actions release workflow, which:
1. Creates a GitHub Release for the tag
2. Builds release binaries for multiple platforms (Linux and macOS)
3. Attaches the binaries to the GitHub Release

## Testing Pre-releases

For pre-releases, add `-alpha.1`, `-beta.1`, etc. to your version:

```bash
# For a beta release
git tag -a v0.2.0-beta.1 -m "Beta release v0.2.0-beta.1"
git push origin v0.2.0-beta.1
```

## Accessing Releases via Nix

Users can access specific versions via Nix Flakes:

```nix
# In flake.nix inputs
inputs.ferronix.url = "github:yourusername/ferronix/v0.1.0";

# Or to use a specific version from the command line
nix run github:yourusername/ferronix/v0.1.0
```