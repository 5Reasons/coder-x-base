# Copilot Instructions for coder-x-base

## Project Overview

This project extends the `codercom/enterprise-base:ubuntu` Docker image to create a development environment optimized for Node.js and Python3 development. The image is built and published to GitHub Container Registry (GHCR) as a public repository.

## Project Structure

```
.
├── Dockerfile                         # Main Docker image definition
├── .github/
│   ├── workflows/
│   │   └── build-and-publish.yml     # CI/CD workflow for building and publishing
│   └── copilot-instructions.md       # Copilot context and guidelines
├── .dockerignore                      # Docker build exclusions
├── README.md                          # Project documentation
└── LICENSE                            # Project license
```

## Docker Image Details

- **Base Image**: `codercom/enterprise-base:ubuntu` (Ubuntu 24.04 Noble)
- **Target Registry**: GitHub Container Registry (ghcr.io)
- **Image Name**: `ghcr.io/5reasons/coder-x-base` (lowercase enforced)
- **Visibility**: Public
- **Purpose**: Development environment for Node.js and Python3
- **Security**: Regularly update to include security patches and latest versions of tools. Container user: `coder` with UID 1000, GID 1000.
- **Current Size**: ~1.9GB (optimized for volume-mounted environments)
- **Platforms**: linux/amd64, linux/arm64

## Development Tools to Include

### Node.js Stack
- Node.js v22 (Latest LTS)
- npm 10.9 (comes with Node.js)
- yarn 1.22 (alternative package manager)
- pnpm 10.13 (fast package manager)
- TypeScript 5.8 (global installation)
- Common development tools (eslint v9.31.0, prettier, nodemon, pm2, ts-node)

### Python3 Stack
- Python 3.12 (System Python from Ubuntu Noble)
- pip 24.0 (Python package manager)
- pipenv 2025.0 (dependency management)
- poetry 2.1 (modern dependency management)
- virtualenv 20.31 (virtual environment management)
- Common development tools (black 24.2, flake8 7.0 as system packages)
- Scientific Libraries: lxml, aiohttp, aiozmq (system packages)

### Shell Environment
- bash (default shell)
- zsh 5.9 with autosuggestions and syntax highlighting

### Additional Development Tools
- Git (Latest version from PPA)
- curl and wget
- vim/nano editors
- build-essential (for compiling native modules)
- gnupg, lsb-release
- Common system utilities

## Dockerfile Guidelines

1. **Multi-stage builds**: Consider using multi-stage builds if needed for optimization
2. **Layer optimization**: Group related commands to minimize layers
3. **Security**: Run as non-root user when possible
4. **Caching**: Order commands from least to most likely to change
5. **Version pinning**: Pin versions for reproducible builds
6. **Cleanup**: Remove package caches and temporary files

## GitHub Actions Workflow

The CI/CD pipeline:

1. **Trigger on**:
   - Push to main branch
   - Pull requests to main
   - Manual workflow dispatch
   - Schedule (weekly for base image updates)

2. **Build Process**:
   - Checkout code
   - Set up Docker Buildx
   - Login to GHCR
   - Build multi-platform images (linux/amd64, linux/arm64)
   - Convert repository name to lowercase for GHCR compatibility
   - Tag with commit SHA and 'latest'
   - Push to registry
   - Clean up old untagged packages (safe cleanup with delete-only-untagged-versions policy)

3. **Security**:
   - Use GitHub token for authentication
   - Safe package cleanup (only untagged versions)
   - Multi-platform builds for broader compatibility

## Environment Variables

Environment variables used:
- `GITHUB_TOKEN`: For GHCR authentication
- Build-time optimizations for volume-mounted development environments

## Best Practices

1. **Documentation**: Keep README.md updated with usage instructions
2. **Versioning**: Use semantic versioning for releases
3. **Testing**: Include basic smoke tests in the workflow
4. **Dependencies**: Regularly update base image and dependencies
5. **Size optimization**: Image optimized for volume-mounted environments (~1.9GB)
6. **Registry Compatibility**: Enforce lowercase naming for GHCR
7. **Safety**: Use safe package cleanup policies (delete-only-untagged-versions)

## Usage Examples

```bash
# Pull the image
docker pull ghcr.io/5reasons/coder-x-base:latest

# Run interactive container
docker run -it --rm ghcr.io/5reasons/coder-x-base:latest bash

# Use in Dockerfile
FROM ghcr.io/5reasons/coder-x-base:latest
```

## Common Commands for Development

When working on this project, you'll typically:

1. **Build locally**:
   ```bash
   docker build -t coder-x-base .
   ```

2. **Test the image**:
   ```bash
   docker run -it --rm coder-x-base node --version
   docker run -it --rm coder-x-base python3 --version
   docker run -it --rm coder-x-base zsh --version
   ```

3. **Check image size**:
   ```bash
   docker images coder-x-base
   ```

4. **Multi-platform build (like CI)**:
   ```bash
   docker buildx build --platform linux/amd64,linux/arm64 -t coder-x-base .
   ```

## Maintenance

- Monitor base image updates from Coder
- Update Node.js and Python versions quarterly
- Review and update development tools annually
- Monitor image vulnerabilities and apply security patches

## Contributing

When contributing to this project:
1. Test builds locally before submitting PRs
2. Update documentation if adding new tools
3. Consider backward compatibility
4. Verify both Node.js and Python3 functionality

## Troubleshooting

Common issues and solutions:
- **Build failures**: Check base image availability and network connectivity
- **Size issues**: Review installed packages and clean up caches
- **Permission issues**: Ensure proper user configuration in Dockerfile
- **Tool conflicts**: Verify version compatibility between tools
- **Registry naming**: Ensure lowercase repository names for GHCR compatibility
- **Package cleanup**: Use safe cleanup policies to avoid deleting tagged versions
