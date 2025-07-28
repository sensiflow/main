#!/bin/bash

# Sensiflow Deployment Manager
# Advanced deployment script with multiple deployment scenarios

set -e

# Load configuration if available
if [ -f "hub-config.env" ]; then
    source hub-config.env
fi

# Default values if not set in config
ORG_NAME=${ORG_NAME:-"sensiflow"}
REPOS=${REPOS:-"sensi-web-api sensi-web instance-manager"}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

show_usage() {
    echo "Sensiflow Deployment Manager"
    echo ""
    echo "Usage: $0 [DEPLOYMENT_TYPE] [OPTIONS]"
    echo ""
    echo "Deployment Types:"
    echo "  full          Deploy complete stack (default)"
    echo "  web-only      Deploy only web components (frontend + API + nginx)"
    echo "  api-only      Deploy only API and dependencies"
    echo "  infrastructure Deploy only infrastructure (DB + RabbitMQ + Media Server)"
    echo "  dev           Deploy development stack (test configuration)"
    echo "  production    Deploy production stack with SSL"
    echo ""
    echo "Options:"
    echo "  --no-build    Skip build step"
    echo "  --recreate    Recreate containers"
    echo "  --scale <service>=<count>  Scale specific service"
    echo "  --env <file>  Use custom environment file"
    echo "  --logs        Show logs after deployment"
    echo "  --health      Check health after deployment"
    echo ""
    echo "Examples:"
    echo "  $0 full"
    echo "  $0 web-only --no-build"
    echo "  $0 dev --logs"
    echo "  $0 production --env production.env"
    echo "  $0 full --scale web-api=2"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        log_error "Docker is not running or not accessible"
        exit 1
    fi
}

# Function to build projects
build_projects() {
    log_info "Building projects..."
    
    if [ -x "./hub-manager.sh" ]; then
        ./hub-manager.sh build
    else
        log_warning "hub-manager.sh not found or not executable. Building manually..."
        
        # Build web frontend
        if [ -d "sensi-web" ]; then
            cd sensi-web
            npm install && npm run build
            mkdir -p ../nginx/static/
            cp -r dist/* ../nginx/static/ 2>/dev/null || true
            cp -r public/* ../nginx/static/ 2>/dev/null || true
            cd ..
        fi
        
        # Build API
        if [ -d "sensi-web-api" ]; then
            cd sensi-web-api
            chmod +x ./gradlew
            ./gradlew bootJar
            cd ..
        fi
    fi
}

# Function to deploy full stack
deploy_full() {
    local compose_file="docker-compose.yml"
    local extra_args="$1"
    
    log_info "Deploying full Sensiflow stack..."
    
    docker compose -f "$compose_file" up --build -d $extra_args
    
    if [ $? -eq 0 ]; then
        log_success "Full stack deployed successfully"
        show_service_info
    else
        log_error "Deployment failed"
        return 1
    fi
}

# Function to deploy web components only
deploy_web_only() {
    local extra_args="$1"
    
    log_info "Deploying web components only..."
    
    docker compose up --build -d nginx web-api $extra_args
    
    if [ $? -eq 0 ]; then
        log_success "Web components deployed successfully"
        log_info "Web Application: http://localhost"
    else
        log_error "Web deployment failed"
        return 1
    fi
}

# Function to deploy API only
deploy_api_only() {
    local extra_args="$1"
    
    log_info "Deploying API and dependencies..."
    
    docker compose up --build -d database broker web-api $extra_args
    
    if [ $? -eq 0 ]; then
        log_success "API deployed successfully"
        log_info "API available at: http://localhost:8090"
    else
        log_error "API deployment failed"
        return 1
    fi
}

# Function to deploy infrastructure only
deploy_infrastructure() {
    local extra_args="$1"
    
    log_info "Deploying infrastructure components..."
    
    docker compose up --build -d database broker media-server dbadmin $extra_args
    
    if [ $? -eq 0 ]; then
        log_success "Infrastructure deployed successfully"
        log_info "Database Admin: http://localhost:8081"
        log_info "RabbitMQ Management: http://localhost:15672"
    else
        log_error "Infrastructure deployment failed"
        return 1
    fi
}

# Function to deploy development stack
deploy_dev() {
    local extra_args="$1"
    
    log_info "Deploying development stack..."
    
    docker compose -f docker-compose.test.yml up --build -d $extra_args
    
    if [ $? -eq 0 ]; then
        log_success "Development stack deployed successfully"
        log_info "Web Application: http://localhost:8080"
    else
        log_error "Development deployment failed"
        return 1
    fi
}

# Function to deploy production stack
deploy_production() {
    local extra_args="$1"
    
    log_info "Deploying production stack with SSL..."
    
    # Check for SSL certificates
    if [ ! -f "server.crt" ] || [ ! -f "server.key" ] || [ ! -f "server.p12" ]; then
        log_warning "SSL certificates not found. Production deployment requires:"
        log_warning "  - server.crt (SSL certificate)"
        log_warning "  - server.key (SSL private key)"
        log_warning "  - server.p12 (Java keystore for API)"
        log_error "Cannot proceed with production deployment"
        return 1
    fi
    
    # Set production environment variables
    export SECURE=true
    export API_SECURE=true
    
    docker compose up --build -d $extra_args
    
    if [ $? -eq 0 ]; then
        log_success "Production stack deployed successfully"
        log_info "Web Application: https://localhost"
        log_info "API Documentation: https://localhost/swagger-ui.html"
    else
        log_error "Production deployment failed"
        return 1
    fi
}

# Function to show service information
show_service_info() {
    log_info "Service Information:"
    echo "  - Web Application: http://localhost"
    echo "  - API Documentation: http://localhost/swagger-ui.html"
    echo "  - Database Admin: http://localhost:8081"
    echo "  - RabbitMQ Management: http://localhost:15672"
    echo "  - Media Server RTSP: rtsp://localhost:8554"
    echo "  - Media Server WebRTC: http://localhost:8889"
}

# Function to check service health
check_health() {
    log_info "Checking service health..."
    
    # Wait a moment for services to start
    sleep 5
    
    # Check web service
    if curl -s http://localhost >/dev/null 2>&1; then
        log_success "Web service is healthy"
    else
        log_warning "Web service may not be ready yet"
    fi
    
    # Check database
    if docker compose exec -T database pg_isready -U postgres >/dev/null 2>&1; then
        log_success "Database is healthy"
    else
        log_warning "Database may not be ready yet"
    fi
    
    # Check RabbitMQ
    if curl -s http://localhost:15672 >/dev/null 2>&1; then
        log_success "RabbitMQ is healthy"
    else
        log_warning "RabbitMQ may not be ready yet"
    fi
}

# Function to show logs
show_logs() {
    log_info "Showing deployment logs..."
    docker compose logs --tail=50 -f
}

# Parse command line arguments
DEPLOYMENT_TYPE="${1:-full}"
shift || true

NO_BUILD=false
RECREATE=false
SHOW_LOGS=false
CHECK_HEALTH_AFTER=false
SCALE_ARGS=""
ENV_FILE=""
EXTRA_COMPOSE_ARGS=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --no-build)
            NO_BUILD=true
            shift
            ;;
        --recreate)
            RECREATE=true
            EXTRA_COMPOSE_ARGS="$EXTRA_COMPOSE_ARGS --force-recreate"
            shift
            ;;
        --scale)
            SCALE_ARGS="$SCALE_ARGS --scale $2"
            shift 2
            ;;
        --env)
            ENV_FILE="$2"
            shift 2
            ;;
        --logs)
            SHOW_LOGS=true
            shift
            ;;
        --health)
            CHECK_HEALTH_AFTER=true
            shift
            ;;
        *)
            log_warning "Unknown option: $1"
            shift
            ;;
    esac
done

# Load custom environment file if specified
if [ -n "$ENV_FILE" ] && [ -f "$ENV_FILE" ]; then
    log_info "Loading environment from $ENV_FILE"
    source "$ENV_FILE"
fi

# Handle help before other operations
if [ "$DEPLOYMENT_TYPE" = "help" ]; then
    show_usage
    exit 0
fi

# Check Docker availability
check_docker

# Build projects unless --no-build is specified
if [ "$NO_BUILD" = false ]; then
    build_projects
fi

# Combine extra arguments
EXTRA_COMPOSE_ARGS="$EXTRA_COMPOSE_ARGS $SCALE_ARGS"

# Deploy based on type
case "$DEPLOYMENT_TYPE" in
    "full")
        deploy_full "$EXTRA_COMPOSE_ARGS"
        ;;
    "web-only")
        deploy_web_only "$EXTRA_COMPOSE_ARGS"
        ;;
    "api-only")
        deploy_api_only "$EXTRA_COMPOSE_ARGS"
        ;;
    "infrastructure")
        deploy_infrastructure "$EXTRA_COMPOSE_ARGS"
        ;;
    "dev")
        deploy_dev "$EXTRA_COMPOSE_ARGS"
        ;;
    "production")
        deploy_production "$EXTRA_COMPOSE_ARGS"
        ;;
    "help"|*)
        show_usage
        exit 0
        ;;
esac

# Post-deployment actions
if [ "$CHECK_HEALTH_AFTER" = true ]; then
    check_health
fi

if [ "$SHOW_LOGS" = true ]; then
    show_logs
fi