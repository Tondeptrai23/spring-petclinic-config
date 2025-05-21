#!/usr/bin/env bash
set -euo pipefail

# uninstall-charts.sh
# Uninstalls all Helm releases in the 'dev' namespace, except config-server.

NAMESPACE="${NAMESPACE:-dev}"
SERVICES=(
  config-server
  discovery-server
  api-gateway
  customers-service
  vets-service
  visits-service
  genai-service
)

echo "Uninstalling Helm releases from namespace: $NAMESPACE"
echo

for service in "${SERVICES[@]}"; do
  if [[ "$service" == "config-server" ]]; then
    echo "  ⚠️  Skipping $service (uninstall separately if needed)"
    echo
    continue
  fi

  if helm status "$service" --namespace "$NAMESPACE" > /dev/null 2>&1; then
    echo "  → Uninstalling $service"
    helm uninstall "$service" --namespace "$NAMESPACE"
    echo "    ✔️  $service uninstalled"
  else
    echo "  ⚠️  Release '$service' not found in '$NAMESPACE'; skipping"
  fi

  echo
done

echo "✅ Done. All specified charts (except config-server) uninstalled from '$NAMESPACE'."
