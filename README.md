# Sensiflow Main Repository - Project Hub

This repository serves as the central hub for the Sensiflow system, containing documentation, configuration files, and management scripts for all Sensiflow organization projects.

## Repository Structure

The repository is structured as follows:

- `docs/`: Contains the documentation for the Sensiflow system.
- `docker/`: Contains the Dockerfiles for the Sensiflow services.
- `project-docs/`: Contains the reports and presentation files for the Sensiflow project.
- `rabbit-init`: Contains the RabbitMQ configuration files.
- `sql`: Contains the SQL scripts for the postgres database.
- **`hub-manager.sh/bat`**: Main hub management script for cloning and building all projects.
- **`deploy.sh`**: Advanced deployment script with multiple deployment scenarios.
- **`repo-manager.sh`**: Repository management script for maintaining all repositories.
- **`hub-config.env`**: Configuration file for customizing hub behavior.

## Sensiflow Organization Projects

This hub manages the following repositories:

- **sensiflow/main** - Central hub repository (this repository)
- **sensiflow/sensi-web-api** - Kotlin-based REST API backend
- **sensiflow/sensi-web** - TypeScript/React frontend application
- **sensiflow/instance-manager** - Python-based image processing service

## Quick Start

### Prerequisites

Before running the project, make sure you have the following installed:
- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/)
- [JDK 17](https://docs.aws.amazon.com/corretto/latest/corretto-17-ug/downloads-list.html)
- [Node.js and npm 9.1.1+](https://nodejs.org/en/download/)
- [Git](https://git-scm.com/downloads)

### Setup and Deployment

1. **Clone this hub repository:**
   ```bash
   git clone https://github.com/sensiflow/main.git
   cd main
   ```

2. **Clone and build all projects:**
   ```bash
   # Linux/macOS/WSL
   ./hub-manager.sh clone
   ./hub-manager.sh build
   
   # Windows
   hub-manager.bat clone
   hub-manager.bat build
   ```

3. **Deploy the complete stack:**
   ```bash
   # Simple deployment
   ./deploy.sh full
   
   # Or use the hub manager
   ./hub-manager.sh deploy
   ```

## Hub Management Commands

### Hub Manager (`hub-manager.sh`)

The main management script for all Sensiflow projects:

```bash
# Clone all repositories
./hub-manager.sh clone [--force]

# Update all repositories
./hub-manager.sh update

# Build all projects
./hub-manager.sh build

# Deploy complete stack
./hub-manager.sh deploy [--no-build]

# Deploy test environment
./hub-manager.sh deploy-test

# Clean built artifacts
./hub-manager.sh clean

# Show repository status
./hub-manager.sh status
```

### Deployment Manager (`deploy.sh`)

Advanced deployment with multiple scenarios:

```bash
# Deploy complete stack
./deploy.sh full

# Deploy only web components
./deploy.sh web-only

# Deploy only API and dependencies
./deploy.sh api-only

# Deploy only infrastructure services
./deploy.sh infrastructure

# Deploy development environment
./deploy.sh dev

# Deploy production with SSL
./deploy.sh production

# Additional options
./deploy.sh full --no-build --logs --health
./deploy.sh full --scale web-api=2
```

### Repository Manager (`repo-manager.sh`)

Advanced repository management:

```bash
# Sync all repositories
./repo-manager.sh sync

# Show detailed status
./repo-manager.sh status

# List branches across repositories
./repo-manager.sh branches

# Show latest commits
./repo-manager.sh commits

# Create backup
./repo-manager.sh backup --backup-dir /path/to/backup

# Clean repositories
./repo-manager.sh clean --force

# Validate repository integrity
./repo-manager.sh validate
```

## Legacy Installation (Deprecated)

The original installation scripts are still available but deprecated:

```bash
# Linux/macOS/WSL
./install.sh

# Windows
./install.bat
```


## Service Access

After deployment, the following services will be available:

| Service | URL | Description |
|---------|-----|-------------|
| Web Application | http://localhost | Main Sensiflow web interface |
| API Documentation | http://localhost/swagger-ui.html | REST API documentation |
| Database Admin | http://localhost:8081 | Adminer database management |
| RabbitMQ Management | http://localhost:15672 | Message broker management |
| Media Server RTSP | rtsp://localhost:8554 | Real-time streaming protocol |
| Media Server WebRTC | http://localhost:8889 | WebRTC streaming interface |

## Configuration

### Environment Configuration

The hub behavior can be customized by editing `hub-config.env`:

```bash
# Organization settings
ORG_NAME=sensiflow
GITHUB_BASE_URL=https://github.com/${ORG_NAME}

# Repository list
REPOS="sensi-web-api sensi-web instance-manager"

# Build settings
WEB_BUILD_COMMAND="npm run build"
API_BUILD_COMMAND="./gradlew bootJar"

# Deployment options
DEFAULT_BUILD_BEFORE_DEPLOY=true
DEFAULT_FORCE_CLONE=false
```

### SSL Configuration

For production deployment with SSL, place the following files in the repository root:
- `server.crt` - SSL certificate
- `server.key` - SSL private key  
- `server.p12` - Java keystore for API (with password set via `KEY_STORE_PASSWORD` environment variable)

### Docker Compose Files

- `docker-compose.yml` - Production deployment configuration
- `docker-compose.test.yml` - Development/testing configuration

## Advanced Usage

### Individual Service Management

You can manage individual repositories:

```bash
# Work with specific repository
./repo-manager.sh status --repo sensi-web
./repo-manager.sh sync --repo sensi-web-api

# Work with specific branch
./repo-manager.sh sync --branch develop
./repo-manager.sh branches --branch feature/new-ui
```

### Deployment Scenarios

```bash
# Development workflow
./hub-manager.sh clone
./deploy.sh dev --logs

# Production workflow
./hub-manager.sh clone
./hub-manager.sh build
./deploy.sh production --health

# Scaling services
./deploy.sh full --scale web-api=2 --scale nginx=2

# Quick restart with new changes
./deploy.sh web-only --recreate
```

### Maintenance Tasks

```bash
# Create backup before major changes
./repo-manager.sh backup --backup-dir /safe/location

# Clean and rebuild everything
./hub-manager.sh clean
./hub-manager.sh build

# Validate repository integrity
./repo-manager.sh validate

# Reset to clean state if needed
./repo-manager.sh reset --force
```

## Troubleshooting

### Common Issues

1. **Docker not running:**
   ```bash
   # Check Docker status
   docker info
   
   # Start Docker service (Linux)
   sudo systemctl start docker
   ```

2. **Port conflicts:**
   ```bash
   # Check which processes are using ports
   netstat -tulpn | grep :80
   netstat -tulpn | grep :8081
   
   # Stop conflicting services or modify port mappings in docker-compose.yml
   ```

3. **Build failures:**
   ```bash
   # Clean and rebuild
   ./hub-manager.sh clean
   ./hub-manager.sh build
   
   # Check individual repository status
   ./repo-manager.sh status
   ```

4. **Permission issues (Linux/macOS):**
   ```bash
   # Make scripts executable
   chmod +x *.sh
   
   # Fix Docker permissions
   sudo usermod -aG docker $USER
   # Log out and log back in
   ```

### Getting Help

- Check service logs: `docker compose logs <service-name>`
- View all logs: `./deploy.sh full --logs`
- Check service health: `./deploy.sh full --health`
- Validate repositories: `./repo-manager.sh validate`

## Development

### Contributing to the Hub

1. Fork this repository
2. Create a feature branch
3. Make your changes to the hub scripts
4. Test with your changes
5. Submit a pull request

### Adding New Repositories

To add new repositories to the hub management:

1. Update `REPOS` in `hub-config.env`
2. Add build instructions to the build functions in scripts if needed
3. Update Docker Compose files if the new service needs orchestration
4. Update this README documentation