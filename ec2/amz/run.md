# Run following commands:

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

chmod 0600 terraform
ssh ec2-user@54.175.219.217 -i terraform 
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
