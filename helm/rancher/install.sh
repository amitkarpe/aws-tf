#!/bin/sh

# https://rancher.com/docs/rancher/v2.6/en/installation/install-rancher-on-k8s/amazon-eks/

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm upgrade --install \
  ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --set controller.service.type=LoadBalancer \
  --version 3.12.0 \
  --create-namespace

echo ""
kubectl get service ingress-nginx-controller --namespace=ingress-nginx
echo ""

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
kubectl create namespace cattle-system

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update
kubectl create namespace cert-manager
# Install the cert-manager Helm chart
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.5.1 \
  --set installCRDs=true

echo "sleep"
echo "sleep"
sleep 10

exit

