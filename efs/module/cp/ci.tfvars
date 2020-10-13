enabled = true

region = "ap-southeast-1"

availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]

namespace = "eg"

stage = "test"

name = "efsci-TF2"

# CI VPC
vpc_id 	= "vpc-0c3898c6a5a22c2c3"
# CI Subnet
subnets	= ["subnet-0965dc5894f969054", "subnet-0fb7d163171d3ab9a"]
# CI SG
security_groups	= ["sg-094d4519edd873a30"]
