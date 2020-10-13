provider "aws" {
  region = var.region
}

module "efs" {
  source     = "git::https://github.com/cloudposse/terraform-aws-efs.git?ref=master"

  region          = var.region
  vpc_id          = var.vpc_id
  subnets         = var.subnets
  security_groups = var.security_groups
  allowed_cidr_blocks = ["0.0.0.0/0"]
  tags = {
        "Name"      	= "efsci-TF2"
        "developer" 	= "amit"
        "env"		= "ci"
  }

}

