#!/bin/bash

# Sensiflow Repository Manager
# Script for managing multiple repositories in the Sensiflow organization

set -e

# Load configuration
if [ -f "hub-config.env" ]; then
    source hub-config.env
fi

# Default values
ORG_NAME=${ORG_NAME:-"sensiflow"}
REPOS=${REPOS:-"sensi-web-api sensi-web instance-manager"}

# Colors
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
    echo "Sensiflow Repository Manager"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  sync          Sync all repositories (pull latest changes)"
    echo "  status        Show detailed status of all repositories"
    echo "  branches      List branches across all repositories"
    echo "  tags          List tags across all repositories"
    echo "  commits       Show latest commits from all repositories"
    echo "  clean         Clean all repositories (remove untracked files)"
    echo "  reset         Reset all repositories to clean state"
    echo "  backup        Create backup of all repositories"
    echo "  restore       Restore repositories from backup"
    echo "  validate      Validate repository integrity"
    echo ""
    echo "Options:"
    echo "  --branch <name>   Work with specific branch"
    echo "  --repo <name>     Work with specific repository only"
    echo "  --force           Force operations"
    echo "  --backup-dir <dir> Specify backup directory"
    echo ""
    echo "Examples:"
    echo "  $0 sync"
    echo "  $0 status --repo sensi-web"
    echo "  $0 branches --branch develop"
    echo "  $0 backup --backup-dir /tmp/sensiflow-backup"
}

# Function to check if repo exists
repo_exists() {
    [ -d "$1" ] && [ -d "$1/.git" ]
}

# Function to execute git command in repository
git_in_repo() {
    local repo="$1"
    local cmd="$2"
    
    if repo_exists "$repo"; then
        cd "$repo"
        eval "$cmd"
        cd ..
    else
        log_error "Repository $repo not found"
        return 1
    fi
}

# Function to sync all repositories
sync_repos() {
    local branch="${1:-main}"
    local specific_repo="$2"
    
    log_info "Syncing repositories to branch: $branch"
    
    for repo in $REPOS; do
        if [ -n "$specific_repo" ] && [ "$repo" != "$specific_repo" ]; then
            continue
        fi
        
        if repo_exists "$repo"; then
            log_info "Syncing $repo..."
            cd "$repo"
            
            # Fetch latest changes
            git fetch origin
            
            # Check if branch exists locally
            if git show-ref --verify --quiet "refs/heads/$branch"; then
                git checkout "$branch"
                git pull origin "$branch"
                log_success "Synced $repo to $branch"
            else
                log_warning "Branch $branch not found in $repo, staying on current branch"
            fi
            
            cd ..
        else
            log_warning "Repository $repo not found locally"
        fi
    done
}

# Function to show detailed status
show_detailed_status() {
    local specific_repo="$1"
    
    log_info "Repository Status Report"
    echo "=========================="
    
    for repo in $REPOS; do
        if [ -n "$specific_repo" ] && [ "$repo" != "$specific_repo" ]; then
            continue
        fi
        
        if repo_exists "$repo"; then
            cd "$repo"
            
            echo ""
            echo -e "${BLUE}Repository: $repo${NC}"
            echo "Current branch: $(git branch --show-current)"
            echo "Latest commit: $(git log -1 --pretty=format:'%h - %s (%cr) <%an>')"
            echo "Status: $(git status --porcelain | wc -l) modified files"
            
            # Check if behind origin
            local behind=$(git rev-list HEAD..origin/$(git branch --show-current) --count 2>/dev/null || echo "0")
            if [ "$behind" -gt 0 ]; then
                echo -e "${YELLOW}Behind origin by $behind commits${NC}"
            fi
            
            # Check for uncommitted changes
            if [ -n "$(git status --porcelain)" ]; then
                echo -e "${YELLOW}Has uncommitted changes${NC}"
            fi
            
            cd ..
        else
            echo -e "${RED}Repository: $repo - NOT CLONED${NC}"
        fi
    done
    echo ""
}

# Function to list branches
list_branches() {
    local target_branch="$1"
    local specific_repo="$2"
    
    log_info "Branch Information"
    echo "=================="
    
    for repo in $REPOS; do
        if [ -n "$specific_repo" ] && [ "$repo" != "$specific_repo" ]; then
            continue
        fi
        
        if repo_exists "$repo"; then
            cd "$repo"
            echo ""
            echo -e "${BLUE}Repository: $repo${NC}"
            
            if [ -n "$target_branch" ]; then
                echo "Branch '$target_branch' status:"
                if git show-ref --verify --quiet "refs/heads/$target_branch"; then
                    echo "  Local: exists"
                else
                    echo "  Local: not found"
                fi
                
                if git show-ref --verify --quiet "refs/remotes/origin/$target_branch"; then
                    echo "  Remote: exists"
                else
                    echo "  Remote: not found"
                fi
            else
                echo "Local branches:"
                git branch --list
                echo "Remote branches:"
                git branch -r --list
            fi
            
            cd ..
        fi
    done
}

# Function to list tags
list_tags() {
    local specific_repo="$1"
    
    log_info "Tag Information"
    echo "==============="
    
    for repo in $REPOS; do
        if [ -n "$specific_repo" ] && [ "$repo" != "$specific_repo" ]; then
            continue
        fi
        
        if repo_exists "$repo"; then
            cd "$repo"
            echo ""
            echo -e "${BLUE}Repository: $repo${NC}"
            
            local tags=$(git tag --list | head -10)
            if [ -n "$tags" ]; then
                echo "Latest tags:"
                echo "$tags"
            else
                echo "No tags found"
            fi
            
            cd ..
        fi
    done
}

# Function to show latest commits
show_commits() {
    local specific_repo="$1"
    
    log_info "Latest Commits"
    echo "=============="
    
    for repo in $REPOS; do
        if [ -n "$specific_repo" ] && [ "$repo" != "$specific_repo" ]; then
            continue
        fi
        
        if repo_exists "$repo"; then
            cd "$repo"
            echo ""
            echo -e "${BLUE}Repository: $repo${NC}"
            git log --oneline -5
            cd ..
        fi
    done
}

# Function to clean repositories
clean_repos() {
    local force="$1"
    local specific_repo="$2"
    
    log_info "Cleaning repositories..."
    
    for repo in $REPOS; do
        if [ -n "$specific_repo" ] && [ "$repo" != "$specific_repo" ]; then
            continue
        fi
        
        if repo_exists "$repo"; then
            cd "$repo"
            
            if [ "$force" = "true" ]; then
                git clean -fd
                log_success "Force cleaned $repo"
            else
                log_info "Would clean the following files in $repo:"
                git clean -nd
            fi
            
            cd ..
        fi
    done
    
    if [ "$force" != "true" ]; then
        log_info "Use --force to actually clean the files"
    fi
}

# Function to reset repositories
reset_repos() {
    local force="$1"
    local specific_repo="$2"
    
    if [ "$force" != "true" ]; then
        log_error "Reset operation requires --force flag"
        return 1
    fi
    
    log_warning "Resetting repositories to clean state..."
    
    for repo in $REPOS; do
        if [ -n "$specific_repo" ] && [ "$repo" != "$specific_repo" ]; then
            continue
        fi
        
        if repo_exists "$repo"; then
            cd "$repo"
            git reset --hard HEAD
            git clean -fd
            log_success "Reset $repo to clean state"
            cd ..
        fi
    done
}

# Function to backup repositories
backup_repos() {
    local backup_dir="${1:-./sensiflow-backup-$(date +%Y%m%d-%H%M%S)}"
    
    log_info "Creating backup in: $backup_dir"
    
    mkdir -p "$backup_dir"
    
    for repo in $REPOS; do
        if repo_exists "$repo"; then
            log_info "Backing up $repo..."
            cp -r "$repo" "$backup_dir/"
            log_success "Backed up $repo"
        fi
    done
    
    # Create backup manifest
    cat > "$backup_dir/BACKUP_INFO.txt" << EOF
Sensiflow Repository Backup
Created: $(date)
Repositories: $REPOS

Repository Status:
EOF
    
    for repo in $REPOS; do
        if repo_exists "$repo"; then
            cd "$repo"
            echo "$repo: $(git rev-parse HEAD) ($(git branch --show-current))" >> "$backup_dir/BACKUP_INFO.txt"
            cd ..
        fi
    done
    
    log_success "Backup completed: $backup_dir"
}

# Function to restore repositories
restore_repos() {
    local backup_dir="$1"
    local force="$2"
    
    if [ ! -d "$backup_dir" ]; then
        log_error "Backup directory not found: $backup_dir"
        return 1
    fi
    
    if [ "$force" != "true" ]; then
        log_error "Restore operation requires --force flag"
        return 1
    fi
    
    log_warning "Restoring repositories from: $backup_dir"
    
    for repo in $REPOS; do
        if [ -d "$backup_dir/$repo" ]; then
            if repo_exists "$repo"; then
                log_warning "Removing existing $repo..."
                rm -rf "$repo"
            fi
            
            log_info "Restoring $repo..."
            cp -r "$backup_dir/$repo" ./
            log_success "Restored $repo"
        else
            log_warning "Backup for $repo not found in backup directory"
        fi
    done
}

# Function to validate repository integrity
validate_repos() {
    local specific_repo="$1"
    
    log_info "Validating repository integrity..."
    
    for repo in $REPOS; do
        if [ -n "$specific_repo" ] && [ "$repo" != "$specific_repo" ]; then
            continue
        fi
        
        if repo_exists "$repo"; then
            cd "$repo"
            
            if git fsck --quiet; then
                log_success "$repo: Repository integrity OK"
            else
                log_error "$repo: Repository integrity issues found"
            fi
            
            cd ..
        else
            log_warning "$repo: Repository not found"
        fi
    done
}

# Parse command line arguments
COMMAND="${1:-help}"
shift || true

BRANCH=""
SPECIFIC_REPO=""
FORCE=false
BACKUP_DIR=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --branch)
            BRANCH="$2"
            shift 2
            ;;
        --repo)
            SPECIFIC_REPO="$2"
            shift 2
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --backup-dir)
            BACKUP_DIR="$2"
            shift 2
            ;;
        *)
            log_warning "Unknown option: $1"
            shift
            ;;
    esac
done

# Execute command
case "$COMMAND" in
    "sync")
        sync_repos "${BRANCH:-main}" "$SPECIFIC_REPO"
        ;;
    "status")
        show_detailed_status "$SPECIFIC_REPO"
        ;;
    "branches")
        list_branches "$BRANCH" "$SPECIFIC_REPO"
        ;;
    "tags")
        list_tags "$SPECIFIC_REPO"
        ;;
    "commits")
        show_commits "$SPECIFIC_REPO"
        ;;
    "clean")
        clean_repos "$FORCE" "$SPECIFIC_REPO"
        ;;
    "reset")
        reset_repos "$FORCE" "$SPECIFIC_REPO"
        ;;
    "backup")
        backup_repos "$BACKUP_DIR"
        ;;
    "restore")
        restore_repos "$BACKUP_DIR" "$FORCE"
        ;;
    "validate")
        validate_repos "$SPECIFIC_REPO"
        ;;
    "help"|*)
        show_usage
        ;;
esac