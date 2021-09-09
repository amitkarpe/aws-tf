#!/bin/sh

export ns=loki
kubectl create ns $ns
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm upgrade --install loki --namespace=${ns} grafana/loki
# helm install loki-grafana grafana/grafana

helm upgrade --install loki --namespace=${ns} grafana/loki-stack  --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false,loki.persistence.enabled=true,loki.persistence.storageClassName=standard,loki.persistence.size=5Gi
kubectl get secret --namespace ${ns} loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
kubectl get secret --namespace ${ns} loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode | pbcopy
echo "http://localhost:3000" | pbcopy
echo "Run port-forward command"
echo ""
echo 'kubectl port-forward --namespace ${ns} service/loki-grafana 3000:80'
echo 'kubectl port-forward --namespace ${ns} service/loki-grafana 3000:80' | pbcopy
echo ""
