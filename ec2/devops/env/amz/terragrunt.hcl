include {
  path = find_in_parent_folders()
}

terraform {
  source = "../..//src/ec2/bastion"
  # source = "${path_relative_from_include()}../..//src/ec2/bastion"
}


inputs = {
  name          = "${basename(get_terragrunt_dir())}"
  aws_region = "ap-southeast-1" # Singapore region

  # RDS VPC
  vpc_id        = "vpc-035eb12babd9ca798"
  aws_accountid = "273828039634"
  # zone_id       = "Z0835483E2DX5MRSK63J"
  key_name      = "bastion_public_key"
  # Amazon Linux 2
  ami           = "ami-0f4929ce4bdd9c9d1"
  # Public
  subnet_id     = "subnet-0d13ba2dcbb0f6d46"
  jumphost_ip   = ["0.0.0.0/0"]
  instance_type = "t3.xlarge"
  disk_space    = "100"
  tags          = { Name = "Bastion"}
}
