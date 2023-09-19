enabled = true

namespace = "ci"

stage = "test"

name = "sftp-ci"
tags = {
        "Name"      	= "sftp-server"
        "developer" 	= "amit"
        "env"		= "be"
  }

# Region & AZ
region = "us-east-1"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
# CI VPC
vpc_id 	= "vpc-056d238ddec53f442"
# CI Subnet
subnets	= ["subnet-0f6b22e5df4b3b9b4", "subnet-032f36cb448cbe748"]
# CI Security Groups
security_groups	= ["sg-0e14d637fea5fd472"]
allowed_cidr_blocks = ["0.0.0.0/0"]
