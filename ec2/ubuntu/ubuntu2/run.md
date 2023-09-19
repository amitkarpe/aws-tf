# Run 

* Make sure you have setup private key in your local machine

```sh
cd ec2/keypair/privatekey
terraform apply -auto-approve
cp -v privatekey.pem ~/.ssh/
chmod 400 ~/.ssh/privatekey.pem
```

* Run terraform

```sh
cd ec2/ubuntu/ubuntu2
terraform init
terraform plan
terraform apply
```

* Verify

```sh
terraform show
terraform output
IP=$(terraform output -json | jq -r .ip.value); echo $IP
ssh ubuntu@$IP -i ~/.ssh/privatekey.pem 
ssh ubuntu@$IP -i ~/.ssh/privatekey.pem "cat ~/.kube/config"
# Replace IP with your Server IP in the following command
awk -v IP="$IP" '{if ($1 == "server:") {$2 = "https://" IP ":6443"}; print}' /tmp/kubeconfig | awk '{if ($1 == "server:") print "    "$0; else print}' | tee /tmp/kubeconfig.new
export KUBECONFIG=/tmp/kubeconfig.new
#ssh ubuntu@$IP -i ~/.ssh/privatekey.pem kubectl get node -o wide
kubectl get node
kubectl get pod -A
```

