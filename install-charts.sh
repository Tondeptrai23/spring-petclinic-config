#!/usr/bin/env bash
set -euo pipefail

source .env

# —————————————
# Configuration (override via env)
# —————————————
CHARTS_ROOT="${CHARTS_ROOT:-helm-charts}"
TEMPLATE_DIR="$CHARTS_ROOT/dev"                          
NAMESPACE="${NAMESPACE:-dev}"
DOCKERHUB_SECRET="${DOCKERHUB_SECRET:-dockerhub-secret}"
DOCKERHUB_REGISTRY="${DOCKERHUB_REGISTRY:-mikenam}"
BUILD_TAG="${BUILD_NUMBER:-latest}"                      

SERVICES=(
  config-server
  discovery-server
  api-gateway
  customers-service
  vets-service
  visits-service
  genai-service
  admin-server
)

echo "Deploying charts from template"

helm upgrade --install petclinic "$TEMPLATE_DIR" \
  --namespace "$NAMESPACE" --create-namespace \
  -f "$TEMPLATE_DIR/values.yaml" \
  --set image.tag="$BUILD_TAG" \
  --set image.pullSecrets[0].name="$DOCKERHUB_SECRET" \
  --set services.config-server.tag="$BUILD_TAG" \
  --set services.api-gateway.tag="$BUILD_TAG" \
  --set services.customers-service.tag="$BUILD_TAG" \
  --set services.vets-service.tag="$BUILD_TAG" \
  --set services.visits-service.tag="$BUILD_TAG" \
  --set services.genai-service.tag="$BUILD_TAG" \
  --set services.admin-server.tag="$BUILD_TAG" \
  --set services.discovery-server.tag="$BUILD_TAG" \


echo "✅ All specified charts (except config-server) are now deployed to '$NAMESPACE'."
