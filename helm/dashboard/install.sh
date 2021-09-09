#!/bin/bash

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install metrics bitnami/metrics-server -f metrics-values.yaml --namespace kube-system --set apiService.create=true
sleep 10
helm ls -n kube-system
kubectl get deployment -n kube-system metrics-metrics-server
kubectl get pod -n kube-system -l app.kubernetes.io/name=metrics-server

helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm install dashboard kubernetes-dashboard/kubernetes-dashboard --namespace kube-system -f dashboard-values.yaml
