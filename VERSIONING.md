# Versioning Guide for Ferronix

Ferronix follows [Semantic Versioning](https://semver.org/) (SemVer) for release management.

## Version Format

Versions follow the format `MAJOR.MINOR.PATCH`:

- **MAJOR** version increases for incompatible API changes
- **MINOR** version increases for backward-compatible functionality additions
- **PATCH** version increases for backward-compatible bug fixes

## Release Process

### Automatic Releases

Ferronix supports automatic releases when you merge changes to the main branch:

1. Update the version number in `Cargo.toml`
2. Commit and merge your changes to the main branch
3. The CI system will automatically:
   - Detect the version change
   - Create a git tag (e.g., `v0.1.0`)
   - Trigger the release workflow

### Manual Releases

You can also create releases manually if needed:

1. Update version numbers in:
   - `Cargo.toml`
   - `flake.nix` (the `version` field if using `ferronixBin`)

2. Create a Git Tag manually:

```bash
# For version 0.1.0
git tag -a v0.1.0 -m "Release v0.1.0"
git push origin v0.1.0
```

### 3. GitHub Actions Release Workflow

Pushing a tag that matches the pattern `v*.*.*` will trigger the GitHub Actions release workflow, which:
1. Creates a GitHub Release for the tag
2. Builds release binaries for multiple platforms and architectures:
   - Linux (x86_64)
   - macOS (x86_64 Intel and ARM64/Apple Silicon M1/M2/M3/M4)
   - Windows (x86_64)
3. Uses Cachix to speed up and cache builds across all platforms (Linux, macOS, and Windows)
4. Attaches the binaries to the GitHub Release

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