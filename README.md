# coder-x-base

A development-ready Docker image extending `codercom/enterprise-base:ubuntu` with Node.js and Python3 development tools.

## Overview

This image provides a comprehensive development environment for both Node.js and Python3 projects, built on top of Coder's enterprise base image. It's designed to be used with [Coder](https://coder.com/) for cloud development environments.

## Included Tools

### Node.js Stack
- **Node.js** (Latest LTS)
- **npm** (Node Package Manager)
- **yarn** (Alternative package manager)
- **pnpm** (Fast, disk space efficient package manager)
- **TypeScript** (Global installation)
- **Development Tools**: eslint, prettier, nodemon, pm2, ts-node

### Python3 Stack

- **Python 3.12** (System Python from Ubuntu Noble)
- **pip** (Python package installer)
- **pipenv** (Dependency management)
- **poetry** (Modern dependency management)
- **virtualenv** (Virtual environment management)
- **Development Tools**: flake8, black (system packages)
- **Scientific Libraries**: lxml, aiohttp, aiozmq
- **PATH Configuration**: Ready for user-installed tools in `/home/coder/.local/bin`

### System Tools

- **Git** (Latest version)
- **Build Tools**: build-essential, gnupg, lsb-release
- **Network Tools**: curl, wget
- **Shells**: bash (default), zsh with autosuggestions and syntax highlighting
- **Editors**: vim (nano available in base)
- **System Utilities**: Standard Ubuntu packages

## Usage

### Pull the Image

```bash
docker pull ghcr.io/5reasons/coder-x-base:latest
```

> **Note**: If you encounter "manifest unknown" errors, the package may need to be made public in the GitHub Container Registry. The image is automatically built and published by the CI/CD pipeline, but organizational package visibility settings may require manual configuration.

### Run Interactively

```bash
docker run -it --rm ghcr.io/5reasons/coder-x-base:latest bash
```

### Use as Base Image

```dockerfile
FROM ghcr.io/5reasons/coder-x-base:latest

# Your application setup
COPY . /workspace
WORKDIR /workspace

# Install dependencies
RUN npm install
RUN pip install -r requirements.txt
```

> **Note**: Replace `ghcr.io/5reasons/coder-x-base:latest` with a specific version tag for production use to ensure reproducible builds.

### Use with Coder

Add to your Coder template:

```hcl
resource "coder_agent" "main" {
  # ... other configuration

  startup_script = <<-EOT
    # Your initialization script
  EOT
}

resource "docker_container" "workspace" {
  image = "ghcr.io/5reasons/coder-x-base:latest"
  # ... other configuration
}
```

## Development

### Building Locally

```bash
# Clone the repository
git clone https://github.com/5Reasons/coder-x-base.git
cd coder-x-base

# Build the image
docker build -t coder-x-base .

# Test the build
docker run -it --rm coder-x-base node --version
docker run -it --rm coder-x-base python3 --version
```

### Testing Tools

Verify all tools are working:

```bash
# Node.js tools
docker run --rm coder-x-base node --version
docker run --rm coder-x-base npm --version
docker run --rm coder-x-base yarn --version
docker run --rm coder-x-base pnpm --version
docker run --rm coder-x-base tsc --version
docker run --rm coder-x-base eslint --version

# Python tools
docker run --rm coder-x-base python3 --version
docker run --rm coder-x-base pip --version
docker run --rm coder-x-base poetry --version
docker run --rm coder-x-base pipenv --version
docker run --rm coder-x-base black --version
docker run --rm coder-x-base python3 -c "import flake8; print('flake8:', flake8.__version__)"

# Shell tools
docker run --rm coder-x-base zsh --version
docker run --rm coder-x-base bash -c "ls /usr/share/zsh/plugins/"
```

## Image Details

- **Registry**: GitHub Container Registry (ghcr.io)
- **Base**: `codercom/enterprise-base:ubuntu`
- **User**: `coder` (UID: 1000, GID: 1000)
- **Platforms**: linux/amd64, linux/arm64
- **Size**: ~1.9GB (optimized for volume-mounted environments)

## CI/CD

The image is automatically built and published using GitHub Actions:

- **Triggers**: Push to main, PRs, manual dispatch, weekly schedule
- **Platforms**: Multi-architecture (AMD64, ARM64)
- **Registry**: GitHub Container Registry (GHCR)
- **Tags**: `latest`, branch names, commit SHAs, dates

## Version Information

To check the versions of installed tools:

```bash
docker run --rm ghcr.io/5reasons/coder-x-base:latest bash -c "
  echo 'Node.js:' && node --version
  echo 'npm:' && npm --version
  echo 'yarn:' && yarn --version
  echo 'pnpm:' && pnpm --version
  echo 'TypeScript:' && tsc --version
  echo 'Python:' && python3 --version
  echo 'pip:' && pip --version
  echo 'poetry:' && poetry --version
  echo 'pipenv:' && pipenv --version
  echo 'black:' && black --version
  echo 'zsh:' && zsh --version
"
```

## Design Philosophy

This image is optimized for cloud development environments where the user's home directory is typically volume-mounted:

- **System-level tools**: Installed globally for all users
- **User-specific tools**: Not pre-installed, allowing users to customize their environment
- **Volume-mount friendly**: Clean user home directory ready for persistent storage overlay
- **Minimal but complete**: Essential development tools without bloat

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally
5. Submit a pull request

Please ensure:

- All tools remain functional
- Image size doesn't grow unreasonably
- Documentation is updated
- Changes are backward compatible

## Security

This image is regularly updated with:

- Latest base image from Coder
- Security patches for all packages
- Updated versions of development tools

## License

[MIT License](LICENSE)

## Support

For issues and questions:

- [GitHub Issues](https://github.com/5Reasons/coder-x-base/issues)
- [Coder Documentation](https://coder.com/docs)
