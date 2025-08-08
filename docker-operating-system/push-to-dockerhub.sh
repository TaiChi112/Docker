#!/bin/bash

# Docker Hub Push Script
# This script automates the process of building and pushing Docker images to Docker Hub

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
DOCKER_USERNAME=""
VERSION="latest"
BUILD_METHOD="commit"  # or "dockerfile"
PUSH_TO_HUB=true

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
    print_success "Docker is running"
}

# Function to login to Docker Hub
docker_login() {
    print_status "Logging into Docker Hub..."
    if ! docker login; then
        print_error "Docker Hub login failed"
        exit 1
    fi
    print_success "Logged into Docker Hub"
}

# Function to get Docker Hub username
get_username() {
    if [ -z "$DOCKER_USERNAME" ]; then
        read -p "Enter your Docker Hub username: " DOCKER_USERNAME
        if [ -z "$DOCKER_USERNAME" ]; then
            print_error "Username cannot be empty"
            exit 1
        fi
    fi
}

# Function to get version tag
get_version() {
    read -p "Enter version tag (default: $VERSION): " input_version
    if [ ! -z "$input_version" ]; then
        VERSION="$input_version"
    fi
}

# Function to commit running containers
commit_containers() {
    print_status "Committing running containers to images..."
    
    # Check if containers are running
    containers=("ubuntu-container" "alpine-container" "ubuntu-dev-container" "alpine-dev-container")
    
    for container in "${containers[@]}"; do
        if docker ps | grep -q "$container"; then
            case $container in
                "ubuntu-container")
                    image_name="$DOCKER_USERNAME/ubuntu-custom:$VERSION"
                    ;;
                "alpine-container")
                    image_name="$DOCKER_USERNAME/alpine-custom:$VERSION"
                    ;;
                "ubuntu-dev-container")
                    image_name="$DOCKER_USERNAME/ubuntu-dev:$VERSION"
                    ;;
                "alpine-dev-container")
                    image_name="$DOCKER_USERNAME/alpine-dev:$VERSION"
                    ;;
            esac
            
            print_status "Committing $container to $image_name"
            docker commit "$container" "$image_name"
            print_success "Committed $container"
        else
            print_warning "Container $container is not running, skipping..."
        fi
    done
}

# Function to build from Dockerfiles
build_from_dockerfiles() {
    print_status "Building images from Dockerfiles..."
    
    export DOCKER_USERNAME="$DOCKER_USERNAME"
    export VERSION="$VERSION"
    
    if ! docker-compose -f docker-compose.build.yml build; then
        print_error "Build failed"
        exit 1
    fi
    
    print_success "Images built successfully"
}

# Function to push images
push_images() {
    print_status "Pushing images to Docker Hub..."
    
    if [ "$BUILD_METHOD" = "commit" ]; then
        images=(
            "$DOCKER_USERNAME/ubuntu-custom:$VERSION"
            "$DOCKER_USERNAME/alpine-custom:$VERSION"
            "$DOCKER_USERNAME/ubuntu-dev:$VERSION"
            "$DOCKER_USERNAME/alpine-dev:$VERSION"
        )
    else
        images=(
            "$DOCKER_USERNAME/ubuntu-custom:$VERSION"
            "$DOCKER_USERNAME/alpine-custom:$VERSION"
        )
    fi
    
    for image in "${images[@]}"; do
        # Check if image exists
        if docker images | grep -q "$(echo "$image" | cut -d':' -f1)"; then
            print_status "Pushing $image"
            if docker push "$image"; then
                print_success "Pushed $image"
            else
                print_error "Failed to push $image"
            fi
        else
            print_warning "Image $image not found, skipping..."
        fi
    done
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -u, --username USERNAME    Docker Hub username"
    echo "  -v, --version VERSION      Version tag (default: latest)"
    echo "  -m, --method METHOD        Build method: commit or dockerfile (default: commit)"
    echo "  -n, --no-push             Build only, don't push to Docker Hub"
    echo "  -h, --help                Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 -u myusername -v v1.0 -m dockerfile"
    echo "  $0 --username myusername --version v1.0 --method commit"
    echo "  $0 -u myusername -n  # Build only, don't push"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--username)
            DOCKER_USERNAME="$2"
            shift 2
            ;;
        -v|--version)
            VERSION="$2"
            shift 2
            ;;
        -m|--method)
            BUILD_METHOD="$2"
            shift 2
            ;;
        -n|--no-push)
            PUSH_TO_HUB=false
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Main execution
main() {
    print_status "Starting Docker Hub push process..."
    
    # Check prerequisites
    check_docker
    
    # Get user input
    get_username
    
    if [ "$BUILD_METHOD" = "commit" ]; then
        get_version
    fi
    
    # Login to Docker Hub
    if [ "$PUSH_TO_HUB" = true ]; then
        docker_login
    fi
    
    # Build or commit images
    if [ "$BUILD_METHOD" = "dockerfile" ]; then
        build_from_dockerfiles
    else
        commit_containers
    fi
    
    # Push images
    if [ "$PUSH_TO_HUB" = true ]; then
        push_images
        print_success "All images pushed successfully!"
        print_status "Visit https://hub.docker.com/u/$DOCKER_USERNAME to see your repositories"
    else
        print_success "Images built successfully (not pushed)"
    fi
}

# Run main function
main
