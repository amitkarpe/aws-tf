include {
  path = find_in_parent_folders()
}

terraform {
  source = "../..//src/ec2/bastion"
  # source = "${path_relative_from_include()}../..//src/ec2/bastion"
}


inputs = {
  name          = "bastion"
  aws_region = "us-east-1"
  vpc_id        = "vpc-0fd862aa2552cb138"
  aws_accountid = "853695258386"
  # zone_id       = "Z0835483E2DX5MRSK63J"
  key_name      = "bastion_public_key"
  # Amazon Linux 2
  ami           = "ami-090fa75af13c156b4"
  # tp-dna-rds-vpc-db-us-east-1a
  subnet_id     = "subnet-0a47d8c01f452adf0"
  subnet_id     = "subnet-0f6b9adf1e7c17923"
  jumphost_ip   = ["0.0.0.0/0"]
  instance_type = "t3.small"
  disk_space    = "100"
}
