#!/usr/bin/env bash
# Runs on the apps EC2 box, invoked over SSM by the GitHub Actions deploy job.
# Pulls the freshly built app + proxy images from ECR and (re)starts the stack.
set -euo pipefail

REGION=us-east-1
ACCOUNT=164452774963
REGISTRY="${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com"
export APP_IMAGE="${REGISTRY}/studybud-app:latest"
export PROXY_IMAGE="${REGISTRY}/studybud-proxy:latest"

cd "$(dirname "$0")"
git pull --ff-only origin main || true

aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "$REGISTRY"
docker pull "$APP_IMAGE"
docker pull "$PROXY_IMAGE"

set -a; . ./.env; set +a
docker compose -f docker-compose.ci.yml up -d
docker image prune -f
echo "deployed studybud"
