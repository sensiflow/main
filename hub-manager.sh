#!/bin/bash

# Sensiflow Hub Manager
# This script manages cloning, building, and deploying all Sensiflow organization projects

set -e  # Exit on error

# Configuration
ORG_NAME="sensiflow"
REPOS=("sensi-web-api" "sensi-web" "instance-manager")
GITHUB_BASE_URL="https://github.com/${ORG_NAME}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to display usage
show_usage() {
    echo "Sensiflow Hub Manager"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  clone         Clone all repositories"
    echo "  update        Update all repositories"
    echo "  build         Build all projects"
    echo "  deploy        Deploy using Docker Compose"
    echo "  deploy-test   Deploy using test configuration"
    echo "  clean         Clean built artifacts"
    echo "  status        Show status of all repositories"
    echo "  help          Show this help message"
    echo ""
    echo "Options:"
    echo "  --force       Force operations (overwrite existing directories)"
    echo "  --no-build    Skip build step when deploying"
    echo "  --verbose     Enable verbose output"
    echo ""
    echo "Examples:"
    echo "  $0 clone --force"
    echo "  $0 build"
    echo "  $0 deploy"
    echo "  $0 status"
}

# Function to check if a repository exists locally
repo_exists() {
    local repo_name="$1"
    [ -d "$repo_name" ]
}

# Function to clone a repository
clone_repo() {
    local repo_name="$1"
    local force="$2"
    
    if repo_exists "$repo_name"; then
        if [ "$force" = "true" ]; then
            log_warning "Repository $repo_name exists. Removing..."
            rm -rf "$repo_name"
        else
            log_warning "Repository $repo_name already exists. Use --force to overwrite."
            return 0
        fi
    fi
    
    log_info "Cloning $repo_name..."
    if git clone "${GITHUB_BASE_URL}/${repo_name}.git"; then
        log_success "Successfully cloned $repo_name"
    else
        log_error "Failed to clone $repo_name"
        return 1
    fi
}

# Function to update a repository
update_repo() {
    local repo_name="$1"
    
    if ! repo_exists "$repo_name"; then
        log_warning "Repository $repo_name not found. Cloning instead..."
        clone_repo "$repo_name" "false"
        return $?
    fi
    
    log_info "Updating $repo_name..."
    cd "$repo_name"
    
    if git pull origin main; then
        log_success "Successfully updated $repo_name"
    else
        log_error "Failed to update $repo_name"
        cd ..
        return 1
    fi
    
    cd ..
}

# Function to build web frontend
build_web() {
    if ! repo_exists "sensi-web"; then
        log_error "sensi-web repository not found. Run 'clone' command first."
        return 1
    fi
    
    log_info "Building web frontend..."
    cd sensi-web
    
    if [ ! -f "package.json" ]; then
        log_error "package.json not found in sensi-web"
        cd ..
        return 1
    fi
    
    # Install dependencies and build
    if npm install && npm run build; then
        log_success "Successfully built web frontend"
        
        # Copy built files to nginx directory
        log_info "Copying built files to nginx directory..."
        mkdir -p ../nginx/static/
        cp -r dist/* ../nginx/static/ 2>/dev/null || true
        cp -r public/* ../nginx/static/ 2>/dev/null || true
        
    else
        log_error "Failed to build web frontend"
        cd ..
        return 1
    fi
    
    cd ..
}

# Function to build web API
build_api() {
    if ! repo_exists "sensi-web-api"; then
        log_error "sensi-web-api repository not found. Run 'clone' command first."
        return 1
    fi
    
    log_info "Building web API..."
    cd sensi-web-api
    
    if [ ! -f "gradlew" ]; then
        log_error "gradlew not found in sensi-web-api"
        cd ..
        return 1
    fi
    
    # Make gradlew executable and build
    chmod +x ./gradlew
    if ./gradlew bootJar; then
        log_success "Successfully built web API"
    else
        log_error "Failed to build web API"
        cd ..
        return 1
    fi
    
    cd ..
}

# Function to show repository status
show_status() {
    log_info "Repository Status:"
    echo ""
    
    for repo in "${REPOS[@]}"; do
        if repo_exists "$repo"; then
            cd "$repo"
            echo -e "${GREEN}✓${NC} $repo - $(git rev-parse --short HEAD) - $(git log -1 --pretty=format:'%s')"
            cd ..
        else
            echo -e "${RED}✗${NC} $repo - Not cloned"
        fi
    done
    echo ""
}

# Function to clean built artifacts
clean_artifacts() {
    log_info "Cleaning built artifacts..."
    
    # Clean web build
    if repo_exists "sensi-web"; then
        rm -rf sensi-web/dist sensi-web/node_modules
        log_info "Cleaned web frontend artifacts"
    fi
    
    # Clean API build
    if repo_exists "sensi-web-api"; then
        rm -rf sensi-web-api/build sensi-web-api/.gradle
        log_info "Cleaned web API artifacts"
    fi
    
    # Clean nginx static files
    rm -rf nginx/static/*
    log_info "Cleaned nginx static files"
    
    log_success "Cleanup completed"
}

# Main command handling
case "${1:-help}" in
    "clone")
        FORCE="false"
        if [[ "$*" == *"--force"* ]]; then
            FORCE="true"
        fi
        
        log_info "Cloning all Sensiflow repositories..."
        for repo in "${REPOS[@]}"; do
            clone_repo "$repo" "$FORCE"
        done
        log_success "Clone operation completed"
        ;;
        
    "update")
        log_info "Updating all repositories..."
        for repo in "${REPOS[@]}"; do
            update_repo "$repo"
        done
        log_success "Update operation completed"
        ;;
        
    "build")
        log_info "Building all projects..."
        build_web
        build_api
        log_success "Build operation completed"
        ;;
        
    "deploy")
        NO_BUILD="false"
        if [[ "$*" == *"--no-build"* ]]; then
            NO_BUILD="true"
        fi
        
        if [ "$NO_BUILD" = "false" ]; then
            log_info "Building projects before deployment..."
            build_web
            build_api
        fi
        
        log_info "Deploying with Docker Compose..."
        if docker compose up --build -d; then
            log_success "Deployment completed successfully"
            log_info "Services available at:"
            log_info "  - Web Application: http://localhost"
            log_info "  - API Documentation: http://localhost/swagger-ui.html"
            log_info "  - Database Admin: http://localhost:8081"
            log_info "  - RabbitMQ Management: http://localhost:15672"
        else
            log_error "Deployment failed"
            return 1
        fi
        ;;
        
    "deploy-test")
        log_info "Deploying with test configuration..."
        if docker compose -f docker-compose.test.yml up --build -d; then
            log_success "Test deployment completed successfully"
        else
            log_error "Test deployment failed"
            return 1
        fi
        ;;
        
    "clean")
        clean_artifacts
        ;;
        
    "status")
        show_status
        ;;
        
    "help"|*)
        show_usage
        ;;
esac