# Run following commands:

## With Your Keys - No need to manually create a keypair. Use your existing keys from "~/.ssh/id_rsa.pub"
## With default security_groups, so need to update specific security_groups [ Added ssh and http access into security_groups ]

* Make sure that you have AWS CLI installed and configured

```
vim ~/.aws/credentials
aws sts get-caller-identity --profile default
```


* Provision the infrastructure using terraform

```
terraform init
terraform plan
terraform apply
terraform output
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
terraform output -json | jq -r .dns.value
terraform output -json | jq -r .ip.value
export dns=$(terraform output -json | jq -r .dns.value)
ssh ec2-user@$dns
```

* Using aws command line, we can get the public IP address of the instance

```
aws ec2 describe-instances --filters "Name=tag:Name,Values=terraform" --query "Reservations[*].Instances[*].PublicIpAddress" --output=text


```


* Destroy the infrastructure

```
terraform destroy
```
