# Run following commands:
## Without Keys - Manually create a keypair using command `ssh-keygen -t rsa -f terraform`
## With default security_groups, so need to update specific security_groups [ Added ssh and http access into security_groups ]


* Make sure that you have AWS CLI installed and configured

```
cat ~/.aws/credentials
aws sts get-caller-identity --profile default
```


* Provision the infrastructure using terraform

```
terraform init
terraform plan
terraform apply
``` 

* Make sure that Security Group allows access to port 22 from your IP address
* SSH into the instance

```
ssh -i <path to private key> ubuntu@<public ip address>
or
ssh -i <path to private key> ec2-user@<public ip address>
```

* In our example, we have provision Amazon Linux 2 instance, so we will use ec2-user as username
```

chmod 0600 mykey
IP=$(terraform output -json | jq -r .ip.value); echo $IP
ssh ec2-user@${IP} -i mykey 
curl -I ${IP}
```

* Using aws command line, we can get the public IP address of the instance

```
aws ec2 describe-instances --filters "Name=tag:Name,Values=terraform" --query "Reservations[*].Instances[*].PublicIpAddress" --output=text

terraform refresh; terraform output
```


* Destroy the infrastructure

```
terraform destroy
```
