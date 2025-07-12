FROM codercom/enterprise-base:ubuntu

# Run everything as root
USER root

# Install additional system dependencies (base image already has curl, wget, git, build-essential, etc.)
RUN DEBIAN_FRONTEND="noninteractive" apt-get update -y && apt-get dist-upgrade -y && \
    apt-get install -y \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js LTS
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - && \
    DEBIAN_FRONTEND="noninteractive" apt-get update -y && \
    apt-get install -y nodejs

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    DEBIAN_FRONTEND="noninteractive" apt-get update && \
    apt-get install -y yarn

# Install pnpm
RUN npm install -g pnpm

# Install global Node.js development tools
RUN npm install -g \
    typescript \
    ts-node \
    eslint \
    prettier \
    nodemon \
    pm2

# Install Python development packages (Python 3.12 and pip already included in base image)
RUN DEBIAN_FRONTEND="noninteractive" apt-get update -y && \
    apt-get install -y \
    python3-dev \
    python3-venv \
    python3-setuptools \
    python3-wheel \
    python3-aiohttp python3-aiohttp-wsgi python3-aiozmq \
    python3-lxml python3-flake8 python3-flake8-black python3-flake8-import-order \
    && rm -rf /var/lib/apt/lists/*

# Create symbolic link for python command (optional, python3 is preferred)
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# Install pipx for global Python tools (pipx is already installed in base image, just ensure path)
# RUN python3 -m pip install --user pipx && \
#     python3 -m pipx ensurepath
# Note: pipx is already installed and ensurepath is already run in the base image

# Install Python package managers and tools
RUN python3 -m pip install --break-system-packages pipenv poetry virtualenv

# Clean up
RUN DEBIAN_FRONTEND="noninteractive" apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set back to coder user
USER coder

# Add uv and local Python packages to PATH for coder user
ENV PATH="/home/coder/.local/bin:/home/coder/.cargo/bin:$PATH"

# Verify installations
RUN node --version && \
    npm --version && \
    yarn --version && \
    pnpm --version && \
    python3 --version && \
    pip --version && \
    poetry --version && \
    pipenv --version
