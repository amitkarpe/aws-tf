# variable "vpc_id" {}
provider "aws" {}

data "aws_vpc" "selected" {
  # id = var.vpc_id 
  default = true
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets
data "aws_subnets" "example" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

data "aws_subnet" "example" {
  for_each = toset(data.aws_subnets.example.ids)
  id       = each.value
}

output "vpc_id" {
  value = data.aws_vpc.selected.id
}

# cidr_block - (Optional) CIDR block of the desired subnet.
output "subnet_cidr_blocks" {
  value = [for s in data.aws_subnet.example : s.cidr_block]
}

# id - (Optional) ID of the specific subnet to retrieve.
output "subnet_ids" {
  value = [for s in data.aws_subnet.example : s.id]
}

# availability_zone - (Optional) Availability zone where the subnet must reside.
output "subnet_az" {
  value = [for s in data.aws_subnet.example : s.availability_zone]
}

# availability_zone_id - (Optional) ID of the Availability Zone for the subnet. This argument is not supported in all regions or partitions. If necessary, use availability_zone instead.
output "subnet_az_ids" {
  value = [for s in data.aws_subnet.example : s.availability_zone_id]
}
