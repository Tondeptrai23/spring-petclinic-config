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
