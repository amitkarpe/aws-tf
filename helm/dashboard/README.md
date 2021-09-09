# Dashboard and Metrics Server 


## [Dashboard](https://github.com/kubernetes/dashboard)
General-purpose web UI for Kubernetes clusters 

```
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm install dashboard kubernetes-dashboard/kubernetes-dashboard
```

Make sure that values.yaml should have image which can be access in private EKS. i.e. If no internet connetion, then docker image download will fail. So upload docker image in private repository.
Following image hosted on Nexus docker-proxy (i.e. this proxy points to docker.io).
```
nexus-docker.ship.gov.sg/bitnami/metrics-server
```



## [Metrics Server ](https://github.com/kubernetes-sigs/metrics-server)
Cluster-wide aggregator of resource usage data. 

```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install metrics bitnami/metrics-server -f values.yaml --namespace kube-system
```

The metrics.k8s.io/v1beta1 API service need to enable by using `--set apiService.create=true` flags.

Ref:
[Metrics Server in Amazon EKS](https://aws.amazon.com/premiumsupport/knowledge-center/eks-metrics-server/)


## Accessing Dashboard using "token"
### [Security]: To use the "token", please create ServiceAccount

"kubernetes-dashboard-admin.rbac.yaml" will add "admin-user" as ServiceAccount in the kube-system namespace. Which can generate token to access dashboard. Use this token and then delete "admin-user" ServiceAccount after use (to avoid any security issue). 

"kubernetes-dashboard-view.rbac.yaml" will add "view-user" as ServiceAccount in the kube-system namespace. Which can generate token to access dashboard. Use this token and no need to delete this ServiceAccount after use, as it is more secure and restricted ServiceAccount name as *view-user*, which can view various cluster, namespace and deployment level information but still have limited permissions. 

```
kubectl apply -f kubernetes-dashboard-admin.rbac.yaml
export POD_NAME=$(kubectl get pods -n kube-system -l "app.kubernetes.io/name=kubernetes-dashboard,app.kubernetes.io/instance=dashboard" -o jsonpath="{.items[0].metadata.name}")
echo https://127.0.0.1:8443/
# If you are using "admin-user" ServiceAccount - kubernetes-dashboard-admin.rbac.yaml
#kubectl get secret $(kubectl get sa/admin-user -n kube-system  -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}" | pbcopy

# If you are using "view-user" ServiceAccount - kubernetes-dashboard-view.rbac.yaml
kubectl get secret -n kube-system $(kubectl get sa/view-user -n kube-system -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}" | pbcopy
kubectl -n kube-system port-forward $POD_NAME 8443:8443
```

Open the dashboard in browser as https://127.0.0.1:8443/ and copy paste the token values from previous command.

PS: As mention previously use following command to delete  "admin-user" ServiceAccount.
```
 ➜ kubectl delete -f kubernetes-dashboard-admin.rbac.yaml
serviceaccount "admin-user" deleted
clusterrolebinding.rbac.authorization.k8s.io "admin-user" deleted
```


# Dashboard [ Quick start ] using kubectl

```
kubectl apply -f kubernetes-dashboard-admin.rbac.yaml
export POD_NAME=$(kubectl get pods -n kube-system -l "app.kubernetes.io/name=kubernetes-dashboard,app.kubernetes.io/instance=dashboard" -o jsonpath="{.items[0].metadata.name}")

echo https://127.0.0.1:8443/
kubectl get secret $(kubectl get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}" | pbcopy
kubectl -n kube-system port-forward $POD_NAME 8443:8443
```

Open the dashboard in browser as https://127.0.0.1:8443/
And copy paste the token values from previous command.
