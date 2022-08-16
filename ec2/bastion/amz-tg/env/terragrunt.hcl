include {
  path = find_in_parent_folders()
}

terraform {
  source = "${path_relative_from_include()}/../src//ec2/bastion"
}


inputs = {
  name          = "bastiong"
  # vpc_id        = ""
  zone_id       = "Z0835483E2DX5MRSK63J"
  key_name      = "bastion_public_key"
  ami           = "ami-090fa75af13c156b4"
  subnet_id     = "subnet-0f59d9b2ac061f36b"
  jumphost_ip   = ["10.130.0.0/24", "10.130.4.0/22", "10.23.0.0/21", "10.21.0.0/21"]
  instance_type = "t3.small"
  disk_space    = "100"
}
