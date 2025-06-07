#!/usr/bin/env bash

# Namespace and service ports
declare -A SERVICES=(
  ["Prometheus"]="monitoring prometheus-operated 9090:9090"
  ["Grafana"]="monitoring prometheus-grafana 3000:80"
  ["Loki"]="logging loki-loki-distributed-gateway 3100:80"
  ["Zipkin"]="tracing zipkin 9411:9411"
  ["Alloy"]="logging alloy 12345:12345"
)

# Start port-forwarding in background for each service
for SERVICE in "${!SERVICES[@]}"; do
  INFO=(${SERVICES[$SERVICE]})
  NAMESPACE=${INFO[0]}
  SERVICE_NAME=${INFO[1]}
  PORTS=${INFO[2]}
  
  echo "Starting port-forward for $SERVICE ($SERVICE_NAME in namespace $NAMESPACE)..."
  
  kubectl port-forward svc/$SERVICE_NAME $PORTS --address 0.0.0.0 -n $NAMESPACE > "$SERVICE-portforward.log" 2>&1 &
  
  echo "$SERVICE is now available at localhost:${PORTS%%:*}"
done

echo "-----------------------------------------"
echo "All port-forwardings are running in the background."
echo "You can check the logs in the respective log files (e.g., Prometheus-portforward.log)."
echo "You can run 'ps aux | grep \"kubectl port-forward\"' to see the running processes."
echo "Use 'ps' to check processes or 'kill' to stop them if needed."
