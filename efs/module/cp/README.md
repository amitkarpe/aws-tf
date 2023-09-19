# Use of Module for EFS
## Module Description

* [Source: Terraform Module to define an EFS Filesystem (aka NFS)](https://github.com/cloudposse/terraform-aws-efs)
* This module is used to create EFS and mount it to the EC2 instance.
* Update respective variable file with appropriate values.
* Run the following commands to create EFS and mount it to the EC2 instance.

```sh
tf apply -auto-approve -var-file=cloudguru.tfvars
```

