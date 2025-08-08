@echo off
setlocal enabledelayedexpansion

:: Docker Hub Push Script for Windows
:: This script automates the process of building and pushing Docker images to Docker Hub

set "DOCKER_USERNAME="
set "VERSION=latest"
set "BUILD_METHOD=commit"
set "PUSH_TO_HUB=true"

:: Function to print status messages
:print_status
echo [INFO] %~1
goto :eof

:print_success
echo [SUCCESS] %~1
goto :eof

:print_error
echo [ERROR] %~1
goto :eof

:print_warning
echo [WARNING] %~1
goto :eof

:: Check if Docker is running
:check_docker
call :print_status "Checking if Docker is running..."
docker info >nul 2>&1
if errorlevel 1 (
    call :print_error "Docker is not running. Please start Docker and try again."
    exit /b 1
)
call :print_success "Docker is running"
goto :eof

:: Login to Docker Hub
:docker_login
call :print_status "Logging into Docker Hub..."
docker login
if errorlevel 1 (
    call :print_error "Docker Hub login failed"
    exit /b 1
)
call :print_success "Logged into Docker Hub"
goto :eof

:: Get Docker Hub username
:get_username
if "%DOCKER_USERNAME%"=="" (
    set /p DOCKER_USERNAME="Enter your Docker Hub username: "
    if "!DOCKER_USERNAME!"=="" (
        call :print_error "Username cannot be empty"
        exit /b 1
    )
)
goto :eof

:: Get version tag
:get_version
set /p input_version="Enter version tag (default: %VERSION%): "
if not "%input_version%"=="" (
    set "VERSION=%input_version%"
)
goto :eof

:: Commit running containers
:commit_containers
call :print_status "Committing running containers to images..."

:: Check ubuntu-container
docker ps | findstr "ubuntu-container" >nul
if not errorlevel 1 (
    call :print_status "Committing ubuntu-container to %DOCKER_USERNAME%/ubuntu-custom:%VERSION%"
    docker commit ubuntu-container %DOCKER_USERNAME%/ubuntu-custom:%VERSION%
    call :print_success "Committed ubuntu-container"
) else (
    call :print_warning "Container ubuntu-container is not running, skipping..."
)

:: Check alpine-container
docker ps | findstr "alpine-container" >nul
if not errorlevel 1 (
    call :print_status "Committing alpine-container to %DOCKER_USERNAME%/alpine-custom:%VERSION%"
    docker commit alpine-container %DOCKER_USERNAME%/alpine-custom:%VERSION%
    call :print_success "Committed alpine-container"
) else (
    call :print_warning "Container alpine-container is not running, skipping..."
)

:: Check ubuntu-dev-container
docker ps | findstr "ubuntu-dev-container" >nul
if not errorlevel 1 (
    call :print_status "Committing ubuntu-dev-container to %DOCKER_USERNAME%/ubuntu-dev:%VERSION%"
    docker commit ubuntu-dev-container %DOCKER_USERNAME%/ubuntu-dev:%VERSION%
    call :print_success "Committed ubuntu-dev-container"
) else (
    call :print_warning "Container ubuntu-dev-container is not running, skipping..."
)

:: Check alpine-dev-container
docker ps | findstr "alpine-dev-container" >nul
if not errorlevel 1 (
    call :print_status "Committing alpine-dev-container to %DOCKER_USERNAME%/alpine-dev:%VERSION%"
    docker commit alpine-dev-container %DOCKER_USERNAME%/alpine-dev:%VERSION%
    call :print_success "Committed alpine-dev-container"
) else (
    call :print_warning "Container alpine-dev-container is not running, skipping..."
)

goto :eof

:: Build from Dockerfiles
:build_from_dockerfiles
call :print_status "Building images from Dockerfiles..."

set "DOCKER_USERNAME=%DOCKER_USERNAME%"
set "VERSION=%VERSION%"

docker-compose -f docker-compose.build.yml build
if errorlevel 1 (
    call :print_error "Build failed"
    exit /b 1
)

call :print_success "Images built successfully"
goto :eof

:: Push images
:push_images
call :print_status "Pushing images to Docker Hub..."

if "%BUILD_METHOD%"=="commit" (
    set images=%DOCKER_USERNAME%/ubuntu-custom:%VERSION% %DOCKER_USERNAME%/alpine-custom:%VERSION% %DOCKER_USERNAME%/ubuntu-dev:%VERSION% %DOCKER_USERNAME%/alpine-dev:%VERSION%
) else (
    set images=%DOCKER_USERNAME%/ubuntu-custom:%VERSION% %DOCKER_USERNAME%/alpine-custom:%VERSION%
)

for %%i in (%images%) do (
    docker images | findstr "%%~i" >nul
    if not errorlevel 1 (
        call :print_status "Pushing %%i"
        docker push %%i
        if not errorlevel 1 (
            call :print_success "Pushed %%i"
        ) else (
            call :print_error "Failed to push %%i"
        )
    ) else (
        call :print_warning "Image %%i not found, skipping..."
    )
)
goto :eof

:: Show usage
:show_usage
echo Usage: %0 [OPTIONS]
echo.
echo Options:
echo   -u USERNAME    Docker Hub username
echo   -v VERSION     Version tag (default: latest)
echo   -m METHOD      Build method: commit or dockerfile (default: commit)
echo   -n             Build only, don't push to Docker Hub
echo   -h             Show this help message
echo.
echo Examples:
echo   %0 -u myusername -v v1.0 -m dockerfile
echo   %0 -u myusername -v v1.0 -m commit
echo   %0 -u myusername -n
goto :eof

:: Parse command line arguments
:parse_args
if "%~1"=="" goto :main
if "%~1"=="-u" (
    set "DOCKER_USERNAME=%~2"
    shift
    shift
    goto :parse_args
)
if "%~1"=="-v" (
    set "VERSION=%~2"
    shift
    shift
    goto :parse_args
)
if "%~1"=="-m" (
    set "BUILD_METHOD=%~2"
    shift
    shift
    goto :parse_args
)
if "%~1"=="-n" (
    set "PUSH_TO_HUB=false"
    shift
    goto :parse_args
)
if "%~1"=="-h" (
    call :show_usage
    exit /b 0
)
call :print_error "Unknown option: %~1"
call :show_usage
exit /b 1

:: Main execution
:main
call :print_status "Starting Docker Hub push process..."

:: Check prerequisites
call :check_docker

:: Get user input
call :get_username

if "%BUILD_METHOD%"=="commit" (
    call :get_version
)

:: Login to Docker Hub
if "%PUSH_TO_HUB%"=="true" (
    call :docker_login
)

:: Build or commit images
if "%BUILD_METHOD%"=="dockerfile" (
    call :build_from_dockerfiles
) else (
    call :commit_containers
)

:: Push images
if "%PUSH_TO_HUB%"=="true" (
    call :push_images
    call :print_success "All images pushed successfully!"
    call :print_status "Visit https://hub.docker.com/u/%DOCKER_USERNAME% to see your repositories"
) else (
    call :print_success "Images built successfully (not pushed)"
)

goto :eof

:: Start the script
call :parse_args %*
