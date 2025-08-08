# Docker Operating Systems - Ubuntu & Alpine

This repository contains Docker Compose configurations for running Ubuntu and Alpine Linux containers.

## Files Structure

```
docker-operating-system/
├── docker-compose.yml          # Full-featured setup with dev tools
├── docker-compose.simple.yml   # Basic setup
├── shared/                     # Shared volume between containers
├── ubuntu-dev/                 # Ubuntu development workspace
├── alpine-dev/                 # Alpine development workspace
└── README.md                   # This file
```

## Available Configurations

### 1. Full Setup (`docker-compose.yml`)

Includes 4 containers:
- **ubuntu**: Basic Ubuntu container
- **alpine**: Basic Alpine container  
- **ubuntu-dev**: Ubuntu with development tools (curl, wget, git, vim, build-essential, python3, nodejs)
- **alpine-dev**: Alpine with development tools (curl, wget, git, vim, build-base, python3, nodejs)

### 2. Simple Setup (`docker-compose.simple.yml`)

Includes 2 basic containers:
- **ubuntu-simple**: Basic Ubuntu container
- **alpine-simple**: Basic Alpine container

## Usage

### Starting the containers

For full setup:
```bash
docker-compose up -d
```

For simple setup:
```bash
docker-compose -f docker-compose.simple.yml up -d
```

### Accessing the containers

**Ubuntu containers:**
```bash
# Basic Ubuntu
docker exec -it ubuntu-container /bin/bash

# Ubuntu with dev tools
docker exec -it ubuntu-dev-container /bin/bash

# Simple Ubuntu
docker exec -it ubuntu-simple /bin/bash
```

**Alpine containers:**
```bash
# Basic Alpine
docker exec -it alpine-container /bin/sh

# Alpine with dev tools
docker exec -it alpine-dev-container /bin/sh

# Simple Alpine
docker exec -it alpine-simple /bin/sh
```

### Stopping the containers

```bash
# Stop all containers
docker-compose down

# Stop simple setup
docker-compose -f docker-compose.simple.yml down

# Stop and remove volumes
docker-compose down -v
```

## Features

### Volumes
- **shared/**: Files shared between all containers
- **ubuntu-dev/**: Ubuntu development workspace
- **alpine-dev/**: Alpine development workspace
- **Persistent data volumes**: For storing data that persists between container restarts

### Networking
- All containers are connected via a custom bridge network (`os_network`)
- Containers can communicate with each other using their service names

### Development Tools (in dev containers)
- **Common tools**: curl, wget, git, vim, nano
- **Build tools**: build-essential (Ubuntu), build-base (Alpine)
- **Languages**: Python3 with pip, Node.js with npm

## Tips

1. **File sharing**: Use the `shared/` directory to transfer files between containers and host
2. **Development**: Use the dev containers for development work with pre-installed tools
3. **Persistence**: Data stored in `/data` within containers will persist between restarts
4. **Network communication**: Containers can reach each other using service names (e.g., `ping ubuntu` from alpine container)

## Pushing Containers to Docker Hub

After building and customizing your containers, you can push them to Docker Hub for sharing or deployment.

### Prerequisites

1. **Docker Hub Account**: Create a free account at [hub.docker.com](https://hub.docker.com)
2. **Docker CLI**: Ensure Docker is installed and running locally

### Step-by-Step Process

#### 1. Login to Docker Hub

```bash
docker login
```

Enter your Docker Hub username and password when prompted.

#### 2. Commit Running Containers to Images

First, make sure your containers are running with your customizations:

```bash
# Start containers
docker-compose up -d

# Make your customizations inside the containers
# (install packages, configure settings, add files, etc.)
```

Then commit the containers to new images:

```bash
# Commit Ubuntu container
docker commit ubuntu-container yourusername/ubuntu-custom:latest

# Commit Alpine container
docker commit alpine-container yourusername/alpine-custom:latest

# Commit Ubuntu dev container
docker commit ubuntu-dev-container yourusername/ubuntu-dev:latest

# Commit Alpine dev container
docker commit alpine-dev-container yourusername/alpine-dev:latest
```

Replace `yourusername` with your actual Docker Hub username.

#### 3. Tag Images (Alternative Method)

If you want to create images with specific tags:

```bash
# Tag with version numbers
docker commit ubuntu-container yourusername/ubuntu-custom:v1.0
docker commit alpine-container yourusername/alpine-custom:v1.0

# Tag with descriptive names
docker commit ubuntu-dev-container yourusername/ubuntu-development:latest
docker commit alpine-dev-container yourusername/alpine-development:latest
```

#### 4. Push Images to Docker Hub

```bash
# Push all your custom images
docker push yourusername/ubuntu-custom:latest
docker push yourusername/alpine-custom:latest
docker push yourusername/ubuntu-dev:latest
docker push yourusername/alpine-dev:latest

# Push versioned images (if created)
docker push yourusername/ubuntu-custom:v1.0
docker push yourusername/alpine-custom:v1.0
```

#### 5. Create Dockerfiles for Reproducible Builds

For better practice, create Dockerfiles to make your builds reproducible:

**Ubuntu Dockerfile (`dockerfiles/Dockerfile.ubuntu-custom`):**
```dockerfile
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install your custom packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    build-essential \
    python3 \
    python3-pip \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Copy custom files (if any)
# COPY ./custom-files/ /workspace/

# Set default command
CMD ["/bin/bash"]
```

**Alpine Dockerfile (`dockerfiles/Dockerfile.alpine-custom`):**
```dockerfile
FROM alpine:latest

# Install your custom packages
RUN apk update && apk add --no-cache \
    curl \
    wget \
    git \
    vim \
    nano \
    build-base \
    python3 \
    py3-pip \
    nodejs \
    npm

# Set working directory
WORKDIR /workspace

# Copy custom files (if any)
# COPY ./custom-files/ /workspace/

# Set default command
CMD ["/bin/sh"]
```

#### 6. Build and Push from Dockerfiles

```bash
# Create dockerfiles directory
mkdir dockerfiles

# Build images from Dockerfiles
docker build -f dockerfiles/Dockerfile.ubuntu-custom -t yourusername/ubuntu-custom:latest .
docker build -f dockerfiles/Dockerfile.alpine-custom -t yourusername/alpine-custom:latest .

# Push the images
docker push yourusername/ubuntu-custom:latest
docker push yourusername/alpine-custom:latest
```

#### 7. Automated Build Setup

Create a `docker-compose.build.yml` for building custom images:

```yaml
version: '3.8'

services:
  ubuntu-custom:
    build:
      context: .
      dockerfile: dockerfiles/Dockerfile.ubuntu-custom
    image: yourusername/ubuntu-custom:latest
    container_name: ubuntu-custom-build

  alpine-custom:
    build:
      context: .
      dockerfile: dockerfiles/Dockerfile.alpine-custom
    image: yourusername/alpine-custom:latest
    container_name: alpine-custom-build
```

Build and push with:
```bash
# Build images
docker-compose -f docker-compose.build.yml build

# Push images
docker-compose -f docker-compose.build.yml push
```

### Best Practices

1. **Use specific tags**: Instead of `:latest`, use version numbers like `:v1.0`, `:v1.1`
2. **Add labels**: Include metadata in your Dockerfiles
3. **Minimize image size**: Remove unnecessary packages and files
4. **Document your images**: Add README files to your Docker Hub repositories
5. **Security scanning**: Enable Docker Hub's security scanning features

### Example Commands Summary

```bash
# 1. Login
docker login

# 2. Start and customize containers
docker-compose up -d
# ... make customizations ...

# 3. Commit containers to images
docker commit ubuntu-container yourusername/ubuntu-custom:v1.0
docker commit alpine-container yourusername/alpine-custom:v1.0

# 4. Push to Docker Hub
docker push yourusername/ubuntu-custom:v1.0
docker push yourusername/alpine-custom:v1.0

# 5. Verify on Docker Hub
# Visit https://hub.docker.com/u/yourusername to see your repositories
```

### Using Your Custom Images

Others can now use your custom images:

```yaml
# In their docker-compose.yml
services:
  my-ubuntu:
    image: yourusername/ubuntu-custom:v1.0
    container_name: my-custom-ubuntu
  
  my-alpine:
    image: yourusername/alpine-custom:v1.0
    container_name: my-custom-alpine
```

## Troubleshooting

- If containers exit immediately, check that Docker is running
- For permission issues with volumes, ensure the directories have proper permissions
- Use `docker-compose logs <service-name>` to check container logs
- Use `docker-compose ps` to check container status
- **Push errors**: Ensure you're logged in (`docker login`) and have push permissions
- **Large image sizes**: Consider using multi-stage builds or `.dockerignore` files
