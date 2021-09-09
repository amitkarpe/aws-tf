#!/bin/bash

kubectl -n kube-system port-forward $POD_NAME 8443:8443
kubectl get secret $(kubectl get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}" | pbcopy
kubectl -n kube-system port-forward $POD_NAME 8443:8443

