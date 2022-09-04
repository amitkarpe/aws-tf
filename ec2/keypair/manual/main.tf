# Source:
# https://github.com/terraform-aws-modules/terraform-aws-key-pair/blob/master/examples/complete/main.tf
provider "aws" {
  region = local.region
}

locals {
  name   = "${replace(basename(path.cwd), "_", "-")}"
  region  = "us-east-1"

  tags = {
    Project    = local.name
    GithubRepo = "terraform-aws-key-pair"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# Key Pair Module
################################################################################

# ssh-keygen -t rsa -f $(basename $(pwd))

# mv $(basename $(pwd)) $(basename $(pwd)).pub ~/.ssh/

resource "aws_key_pair" "key" {
  key_name   = local.name
  public_key = file("${local.name}.pub")
  tags = local.tags
}