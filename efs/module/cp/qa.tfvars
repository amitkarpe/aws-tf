enabled = true

region = "ap-southeast-1"

availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]

namespace = "eg"

stage = "test"

name = "efsci-TF2"

vpc_id 	= "vpc-058be16ebd7dd4e86"
subnets	= ["subnet-04b34f93989c4c9b9", "subnet-042f1481e760b9893"]
security_groups	= ["sg-0f29f600c185b0c70"]
