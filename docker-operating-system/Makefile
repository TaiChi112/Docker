# Docker Operating Systems Makefile

.PHONY: help up down logs shell-ubuntu shell-alpine clean simple-up simple-down build push

# Default target
help:
	@echo "Available commands:"
	@echo "  up           - Start all containers (full setup)"
	@echo "  down         - Stop all containers (full setup)"
	@echo "  simple-up    - Start containers (simple setup)"
	@echo "  simple-down  - Stop containers (simple setup)"
	@echo "  build        - Build custom images from Dockerfiles"
	@echo "  push         - Push images to Docker Hub (interactive)"
	@echo "  commit-push  - Commit running containers and push to Docker Hub"
	@echo "  logs         - Show logs for all containers"
	@echo "  shell-ubuntu - Open bash shell in Ubuntu container"
	@echo "  shell-alpine - Open sh shell in Alpine container"
	@echo "  clean        - Stop containers and remove volumes"
	@echo "  status       - Show container status"

# Full setup commands
up:
	docker-compose up -d
	@echo "Containers started. Use 'make shell-ubuntu' or 'make shell-alpine' to access them."

down:
	docker-compose down

# Simple setup commands
simple-up:
	docker-compose -f docker-compose.simple.yml up -d
	@echo "Simple containers started."

simple-down:
	docker-compose -f docker-compose.simple.yml down

# Utility commands
logs:
	docker-compose logs -f

logs-simple:
	docker-compose -f docker-compose.simple.yml logs -f

shell-ubuntu:
	@echo "Connecting to Ubuntu container..."
	@if docker ps | grep -q ubuntu-container; then \
		docker exec -it ubuntu-container /bin/bash; \
	elif docker ps | grep -q ubuntu-simple; then \
		docker exec -it ubuntu-simple /bin/bash; \
	else \
		echo "No Ubuntu container is running. Start with 'make up' or 'make simple-up'"; \
	fi

shell-alpine:
	@echo "Connecting to Alpine container..."
	@if docker ps | grep -q alpine-container; then \
		docker exec -it alpine-container /bin/sh; \
	elif docker ps | grep -q alpine-simple; then \
		docker exec -it alpine-simple /bin/sh; \
	else \
		echo "No Alpine container is running. Start with 'make up' or 'make simple-up'"; \
	fi

shell-ubuntu-dev:
	@echo "Connecting to Ubuntu dev container..."
	@if docker ps | grep -q ubuntu-dev-container; then \
		docker exec -it ubuntu-dev-container /bin/bash; \
	else \
		echo "Ubuntu dev container is not running. Start with 'make up'"; \
	fi

shell-alpine-dev:
	@echo "Connecting to Alpine dev container..."
	@if docker ps | grep -q alpine-dev-container; then \
		docker exec -it alpine-dev-container /bin/sh; \
	else \
		echo "Alpine dev container is not running. Start with 'make up'"; \
	fi

status:
	@echo "Full setup containers:"
	@docker-compose ps
	@echo ""
	@echo "Simple setup containers:"
	@docker-compose -f docker-compose.simple.yml ps

clean:
	docker-compose down -v
	docker-compose -f docker-compose.simple.yml down -v
	@echo "All containers stopped and volumes removed."

# Pull latest images
pull:
	docker-compose pull
	docker-compose -f docker-compose.simple.yml pull

# Docker Hub operations
build:
	@echo "Building custom images from Dockerfiles..."
	@read -p "Enter your Docker Hub username: " username; \
	read -p "Enter version tag (default: latest): " version; \
	version=$${version:-latest}; \
	DOCKER_USERNAME=$$username VERSION=$$version docker-compose -f docker-compose.build.yml build
	@echo "Images built successfully!"

push:
	@echo "Running push script..."
	@if [ -f "push-to-dockerhub.sh" ]; then \
		chmod +x push-to-dockerhub.sh && ./push-to-dockerhub.sh; \
	else \
		echo "Push script not found. Please run the push-to-dockerhub.sh script manually."; \
	fi

commit-push:
	@echo "Committing containers and pushing to Docker Hub..."
	@if [ -f "push-to-dockerhub.sh" ]; then \
		chmod +x push-to-dockerhub.sh && ./push-to-dockerhub.sh -m commit; \
	else \
		echo "Push script not found. Please run the push-to-dockerhub.sh script manually."; \
	fi

dockerfile-push:
	@echo "Building from Dockerfiles and pushing to Docker Hub..."
	@if [ -f "push-to-dockerhub.sh" ]; then \
		chmod +x push-to-dockerhub.sh && ./push-to-dockerhub.sh -m dockerfile; \
	else \
		echo "Push script not found. Please run the push-to-dockerhub.sh script manually."; \
	fi
