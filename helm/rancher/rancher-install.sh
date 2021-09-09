#!/bin/sh

# Install Rancher with Helm and Your Chosen Certificate Option
#export ns="adfb7868e02d340c9a3d6ac60c1c4a8e-1861451456.ap-southeast-2.elb.amazonaws.com"
echo "Note down the load balancer hostname"
kubectl get service ingress-nginx-controller -n ingress-nginx -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"
echo ""
export ns=$(kubectl get service ingress-nginx-controller -n ingress-nginx -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")
helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=${ns} \
  --set bootstrapPassword=admin

#echo https://a05d2958228db45b6b82f57a5d9acda3-1876036136.ap-southeast-2.elb.amazonaws.com/dashboard/\?setup\=$\(kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}'\)
export user=$(kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}')
echo ${ns}/dashboard/\?setup\=${user}
