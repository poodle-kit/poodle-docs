#!/bin/bash

# Poodle Docs - Initial Deployment Script
# This script sets up production and dev containers with Watchtower auto-update

set -e

# GitHub Container Registry Configuration
GHCR_USERNAME="${GHCR_USERNAME:-}"
GHCR_TOKEN="${GHCR_TOKEN:-}"
IMAGE_NAME="ghcr.io/poodle-kit/poodle-docs"

# Port Configuration
PROD_PORT=3000
DEV_PORT=3099

echo "🚀 Poodle Docs - Initial Deployment"
echo "===================================="
echo ""

# Check if GHCR credentials are provided
if [ -z "$GHCR_USERNAME" ] || [ -z "$GHCR_TOKEN" ]; then
    echo "⚠️  GHCR credentials not found in environment variables"
    echo ""
    echo "Please set GHCR_USERNAME and GHCR_TOKEN:"
    echo "  export GHCR_USERNAME=your-github-username"
    echo "  export GHCR_TOKEN=your-github-token"
    echo ""
    echo "Or run with:"
    echo "  GHCR_USERNAME=user GHCR_TOKEN=token ./initial-deploy.sh"
    exit 1
fi

# Login to GitHub Container Registry
echo "🔐 Logging in to GitHub Container Registry..."
echo "$GHCR_TOKEN" | docker login ghcr.io -u "$GHCR_USERNAME" --password-stdin

# Pull images
echo ""
echo "📥 Pulling images..."
docker pull "${IMAGE_NAME}:latest"
docker pull "${IMAGE_NAME}:dev"

# Deploy Production
echo ""
echo "🌐 Deploying Production (Port: $PROD_PORT)..."
docker stop poodle-docs-prod 2>/dev/null || true
docker rm poodle-docs-prod 2>/dev/null || true

docker run -d \
  --name poodle-docs-prod \
  --restart unless-stopped \
  -p $PROD_PORT:3000 \
  -l "com.centurylinklabs.watchtower.enable=true" \
  "${IMAGE_NAME}:latest"

echo "✅ Production deployed on port $PROD_PORT"

# Deploy Dev
echo ""
echo "🔧 Deploying Dev (Port: $DEV_PORT)..."
docker stop poodle-docs-dev 2>/dev/null || true
docker rm poodle-docs-dev 2>/dev/null || true

docker run -d \
  --name poodle-docs-dev \
  --restart unless-stopped \
  -p $DEV_PORT:3000 \
  -l "com.centurylinklabs.watchtower.enable=true" \
  "${IMAGE_NAME}:dev"

echo "✅ Dev deployed on port $DEV_PORT"

# Verify deployment
echo ""
echo "🔍 Verifying deployment..."
docker ps | grep poodle-docs

echo ""
echo "✅ Initial deployment completed!"
echo ""
echo "📋 Summary:"
echo "  Production: http://localhost:$PROD_PORT (poodle-kit.my)"
echo "  Dev:        http://localhost:$DEV_PORT (dev.poodle-kit.my)"
echo ""
echo "🤖 Watchtower will automatically update these containers every 5 minutes"
echo "   when new images are pushed to GHCR"
