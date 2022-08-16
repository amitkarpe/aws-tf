include {
  path = find_in_parent_folders()
}

terraform {
  source = "../..//src/ec2/bastion"
  # source = "${path_relative_from_include()}../..//src/ec2/bastion"
}


inputs = {
  name          = "${basename(get_terragrunt_dir())}"
  aws_region = "us-east-1"
  # RDS VPC
  vpc_id        = "vpc-017c75e163c9583cc"
  aws_accountid = "853695258386"
  # zone_id       = "Z0835483E2DX5MRSK63J"
  key_name      = "bastion_public_key"
  # Amazon Linux 2
  ami           = "ami-090fa75af13c156b4"
  # Public
  subnet_id     = "subnet-0d37c9719575309c7"
  jumphost_ip   = ["0.0.0.0/0"]
  instance_type = "t3.small"
  disk_space    = "100"
}
