## Run kind

```bash
kind create cluster --config kind-config.yaml
kubectl config set-cluster kind-petclinic --server https://127.0.0.1:9443

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

kubectl patch svc ingress-nginx-controller \
    -n ingress-nginx \
    --type=json \
    -p='[
        {"op":"replace","path":"/spec/type","value":"NodePort"},
        {"op":"add","path":"/spec/ports/0/nodePort","value":30080},
        {"op":"add","path":"/spec/ports/1/nodePort","value":30443}
    ]'
```

Get Config data --> copy to file

```bash
cat ~/.kube/config
```

## Run argocd

```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

argocd admin initial-password -n argocd

kubectl port-forward svc/argocd-server -n argocd 38080:443 --address 0.0.0.0
```

## Install project 3

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add zipkin https://zipkin.io/zipkin-helm
helm repo update

## Monitoring
kubectl create namespace monitoring
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
    --namespace monitoring \
    -f prometheus/prometheus.yaml

## Upgrade prometheus rules
kubectl apply -f prometheus/rules.yaml -n monitoring



## GET ADMIN PASSWORD TO ACCESS GRAFANA
kubectl get secret --namespace monitoring prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode; echo


## Logging
kubectl create namespace logging
helm install loki grafana/loki-distributed --namespace logging \
  --set gateway.enabled=true \
  --set gateway.service.type=ClusterIP \
  --set persistence.enabled=true \
  --set persistence.storageClassName=standard \
  --set persistence.size=10Gi

kubectl create namespace tracing
helm upgrade --install zipkin zipkin/zipkin \
  --namespace tracing  \
  -f zipkin-lab-values.yaml


## PORT FORWARDING FOR LOCAL TESTING
kubectl port-forward svc/prometheus-operated 9090:9090 -n monitoring --address 0.0.0.0
kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring --address 0.0.0.0
kubectl port-forward svc/loki-loki-distributed-gateway 3100:80 -n logging --address 0.0.0.0
kubectl port-forward svc/zipkin 9411:9411 -n tracing --address 0.0.0.0
## Or you can run
./port-forwarding.sh
```
