- `helm repo add prometheus-community https://prometheus-community.github.io/helm-charts`
- `helm repo list`
- `helm repo update prometheus-community`
- `helm search repo kube-prometheus-stack`
- `helm install prometheus prometheus-community/kube-prometheus-stack`
- `helm ls`
- `k get svc prometheus-operated`
- `k port-forward svc/prometheus-operated 8080:9090`
- Browse the url `localhost:8080` to access the prometheus dashboard.
- `helm uninstall prometheus`