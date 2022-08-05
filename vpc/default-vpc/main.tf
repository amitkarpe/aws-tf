# variable "vpc_id" {}
provider "aws" {}

data "aws_vpc" "selected" {
  # id = var.vpc_id 
  default = true
}

output "vpc_id" {
  value = data.aws_vpc.selected.id
}