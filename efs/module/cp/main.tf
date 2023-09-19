provider "aws" {
  region = var.region
}

module "efs" {
  source = "cloudposse/efs/aws"
  region          = var.region
  vpc_id          = var.vpc_id
  subnets         = var.subnets
  security_groups = var.security_groups
}