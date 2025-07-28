@echo off
setlocal enabledelayedexpansion

REM Sensiflow Hub Manager for Windows
REM This script manages cloning, building, and deploying all Sensiflow organization projects

set "ORG_NAME=sensiflow"
set "GITHUB_BASE_URL=https://github.com/%ORG_NAME%"
set "REPOS=sensi-web-api sensi-web instance-manager"

REM Check command line arguments
if "%1"=="" goto show_usage
if "%1"=="help" goto show_usage

REM Main command handling
if "%1"=="clone" goto clone_repos
if "%1"=="update" goto update_repos
if "%1"=="build" goto build_projects
if "%1"=="deploy" goto deploy_stack
if "%1"=="deploy-test" goto deploy_test
if "%1"=="clean" goto clean_artifacts
if "%1"=="status" goto show_status
goto show_usage

:show_usage
echo.
echo Sensiflow Hub Manager
echo.
echo Usage: %0 [COMMAND] [OPTIONS]
echo.
echo Commands:
echo   clone         Clone all repositories
echo   update        Update all repositories
echo   build         Build all projects
echo   deploy        Deploy using Docker Compose
echo   deploy-test   Deploy using test configuration
echo   clean         Clean built artifacts
echo   status        Show status of all repositories
echo   help          Show this help message
echo.
echo Options:
echo   --force       Force operations (overwrite existing directories)
echo   --no-build    Skip build step when deploying
echo.
echo Examples:
echo   %0 clone --force
echo   %0 build
echo   %0 deploy
echo   %0 status
echo.
goto :eof

:log_info
echo [INFO] %~1
goto :eof

:log_success
echo [SUCCESS] %~1
goto :eof

:log_warning
echo [WARNING] %~1
goto :eof

:log_error
echo [ERROR] %~1
goto :eof

:clone_repos
call :log_info "Cloning all Sensiflow repositories..."

for %%r in (%REPOS%) do (
    if exist "%%r" (
        if "%2"=="--force" (
            call :log_warning "Repository %%r exists. Removing..."
            rmdir /s /q "%%r"
        ) else (
            call :log_warning "Repository %%r already exists. Use --force to overwrite."
            goto skip_clone_%%r
        )
    )
    
    call :log_info "Cloning %%r..."
    git clone "%GITHUB_BASE_URL%/%%r.git"
    if errorlevel 1 (
        call :log_error "Failed to clone %%r"
    ) else (
        call :log_success "Successfully cloned %%r"
    )
    
    :skip_clone_%%r
)

call :log_success "Clone operation completed"
goto :eof

:update_repos
call :log_info "Updating all repositories..."

for %%r in (%REPOS%) do (
    if exist "%%r" (
        call :log_info "Updating %%r..."
        cd "%%r"
        git pull origin main
        if errorlevel 1 (
            call :log_error "Failed to update %%r"
        ) else (
            call :log_success "Successfully updated %%r"
        )
        cd ..
    ) else (
        call :log_warning "Repository %%r not found. Run 'clone' command first."
    )
)

call :log_success "Update operation completed"
goto :eof

:build_projects
call :log_info "Building all projects..."

REM Build web frontend
if not exist "sensi-web" (
    call :log_error "sensi-web repository not found. Run 'clone' command first."
    goto build_api
)

call :log_info "Building web frontend..."
cd sensi-web

if not exist "package.json" (
    call :log_error "package.json not found in sensi-web"
    cd ..
    goto build_api
)

call npm install
if errorlevel 1 (
    call :log_error "Failed to install npm dependencies"
    cd ..
    goto build_api
)

call npm run build
if errorlevel 1 (
    call :log_error "Failed to build web frontend"
    cd ..
    goto build_api
)

call :log_success "Successfully built web frontend"

REM Copy built files to nginx directory
call :log_info "Copying built files to nginx directory..."
if not exist "..\nginx\static\" mkdir "..\nginx\static\"
xcopy /E /I /Y "dist\*" "..\nginx\static\" >nul 2>&1
xcopy /E /I /Y "public\*" "..\nginx\static\" >nul 2>&1

cd ..

:build_api
if not exist "sensi-web-api" (
    call :log_error "sensi-web-api repository not found. Run 'clone' command first."
    goto build_complete
)

call :log_info "Building web API..."
cd sensi-web-api

if not exist "gradlew.bat" (
    call :log_error "gradlew.bat not found in sensi-web-api"
    cd ..
    goto build_complete
)

call gradlew.bat bootJar
if errorlevel 1 (
    call :log_error "Failed to build web API"
    cd ..
    goto build_complete
)

call :log_success "Successfully built web API"
cd ..

:build_complete
call :log_success "Build operation completed"
goto :eof

:deploy_stack
set "NO_BUILD=false"
if "%2"=="--no-build" set "NO_BUILD=true"

if "%NO_BUILD%"=="false" (
    call :log_info "Building projects before deployment..."
    call :build_projects
)

call :log_info "Deploying with Docker Compose..."
docker compose up --build -d
if errorlevel 1 (
    call :log_error "Deployment failed"
    goto :eof
)

call :log_success "Deployment completed successfully"
call :log_info "Services available at:"
call :log_info "  - Web Application: http://localhost"
call :log_info "  - API Documentation: http://localhost/swagger-ui.html"
call :log_info "  - Database Admin: http://localhost:8081"
call :log_info "  - RabbitMQ Management: http://localhost:15672"
goto :eof

:deploy_test
call :log_info "Deploying with test configuration..."
docker compose -f docker-compose.test.yml up --build -d
if errorlevel 1 (
    call :log_error "Test deployment failed"
) else (
    call :log_success "Test deployment completed successfully"
)
goto :eof

:clean_artifacts
call :log_info "Cleaning built artifacts..."

if exist "sensi-web\dist" rmdir /s /q "sensi-web\dist"
if exist "sensi-web\node_modules" rmdir /s /q "sensi-web\node_modules"
if exist "sensi-web-api\build" rmdir /s /q "sensi-web-api\build"
if exist "sensi-web-api\.gradle" rmdir /s /q "sensi-web-api\.gradle"
if exist "nginx\static" rmdir /s /q "nginx\static"

call :log_success "Cleanup completed"
goto :eof

:show_status
call :log_info "Repository Status:"
echo.

for %%r in (%REPOS%) do (
    if exist "%%r" (
        cd "%%r"
        for /f "tokens=*" %%i in ('git rev-parse --short HEAD') do set "commit=%%i"
        for /f "tokens=*" %%i in ('git log -1 --pretty^=format:%%s') do set "message=%%i"
        echo ✓ %%r - !commit! - !message!
        cd ..
    ) else (
        echo ✗ %%r - Not cloned
    )
)
echo.
goto :eof