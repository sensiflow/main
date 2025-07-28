#!/bin/bash

# Sensiflow Hub Demo Script
# This script demonstrates the basic hub functionality

echo "🚀 Sensiflow Hub Demo"
echo "====================="
echo ""

# Check if we're in the right directory
if [ ! -f "hub-manager.sh" ]; then
    echo "❌ Please run this script from the Sensiflow main repository directory"
    exit 1
fi

echo "📋 Available hub commands:"
echo ""
echo "1. Hub Manager (hub-manager.sh):"
echo "   - clone, update, build, deploy, status"
echo ""
echo "2. Deployment Manager (deploy.sh):"
echo "   - full, web-only, api-only, infrastructure, dev, production"
echo ""
echo "3. Repository Manager (repo-manager.sh):"
echo "   - sync, status, branches, commits, backup, clean"
echo ""

# Check current status
echo "📊 Current repository status:"
./hub-manager.sh status
echo ""

echo "📝 Detailed repository information:"
./repo-manager.sh status
echo ""

echo "💡 Example commands to try:"
echo ""
echo "   # Clone all repositories (if not already cloned)"
echo "   ./hub-manager.sh clone"
echo ""
echo "   # Build all projects"
echo "   ./hub-manager.sh build"
echo ""
echo "   # Deploy development environment"
echo "   ./deploy.sh dev --no-build"
echo ""
echo "   # Show latest commits"
echo "   ./repo-manager.sh commits"
echo ""
echo "   # Create backup"
echo "   ./repo-manager.sh backup"
echo ""

echo "✅ Hub demo completed!"
echo ""
echo "💻 For more information, see the updated README.md"