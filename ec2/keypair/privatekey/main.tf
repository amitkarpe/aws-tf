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

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# mv $(basename $(pwd)).pem ~/.ssh/

resource "aws_key_pair" "kp" {
  key_name   = local.name
  public_key = tls_private_key.pk.public_key_openssh
  tags = local.tags
}

resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.kp.key_name}.pem"
  file_permission = "0400"
  content = tls_private_key.pk.private_key_pem
}