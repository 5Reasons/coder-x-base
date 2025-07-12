# Copilot Instructions for coder-x-base

## Project Overview

This project extends the `codercom/enterprise-base:ubuntu` Docker image to create a development environment optimized for Node.js and Python3 development. The image is built and published to GitHub Container Registry (GHCR) as a public repository.

## Project Structure

```
.
├── Dockerfile                    # Main Docker image definition
├── .github/
│   └── workflows/
│       └── build-and-publish.yml # CI/CD workflow for building and publishing
├── .dockerignore                 # Docker build exclusions
├── README.md                     # Project documentation
└── LICENSE                       # Project license
```

## Docker Image Details

- **Base Image**: `codercom/enterprise-base:ubuntu`
- **Target Registry**: GitHub Container Registry (ghcr.io)
- **Image Name**: `ghcr.io/5reasons/coder-x-base`
- **Visibility**: Public
- **Purpose**: Development environment for Node.js and Python3
- **Security**: Regularly update to include security patches and latest versions of tools. Container user: `coder` with UID 1000, GID 1000.

## Development Tools to Include

### Node.js Stack
- Node.js (latest LTS version)
- npm (comes with Node.js)
- yarn (alternative package manager)
- pnpm (fast package manager)
- TypeScript (global installation)
- Common development tools (eslint, prettier, etc.)

### Python3 Stack
- Python 3.12+ (latest stable)
- pip (Python package manager)
- pipenv (dependency management)
- poetry (modern dependency management)
- virtualenv (virtual environment management)
- uv and uvx (virtual environment management tools)
- Common development tools (black, flake8, pytest, etc.)

### Additional Development Tools
- Git (latest version)
- curl and wget
- vim/nano editors
- build-essential (for compiling native modules)
- Common system utilities

## Dockerfile Guidelines

1. **Multi-stage builds**: Consider using multi-stage builds if needed for optimization
2. **Layer optimization**: Group related commands to minimize layers
3. **Security**: Run as non-root user when possible
4. **Caching**: Order commands from least to most likely to change
5. **Version pinning**: Pin versions for reproducible builds
6. **Cleanup**: Remove package caches and temporary files

## GitHub Actions Workflow

The CI/CD pipeline should:

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
   - Tag with commit SHA and 'latest'
   - Push to registry

3. **Security**:
   - Use GitHub token for authentication
   - Scan images for vulnerabilities
   - Sign images with cosign (optional)

## Environment Variables

Expected environment variables:
- `GITHUB_TOKEN`: For GHCR authentication
- `NODE_VERSION`: Node.js version to install (default: LTS)
- `PYTHON_VERSION`: Python version to install (default: 3.12)

## Best Practices

1. **Documentation**: Keep README.md updated with usage instructions
2. **Versioning**: Use semantic versioning for releases
3. **Testing**: Include basic smoke tests in the workflow
4. **Dependencies**: Regularly update base image and dependencies
5. **Size optimization**: Keep image size reasonable (< 2GB if possible)

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
   ```

3. **Check image size**:
   ```bash
   docker images coder-x-base
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
