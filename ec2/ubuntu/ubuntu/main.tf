# Ubuntu with apache web server
# Provisions an EC2 instance on AWS using existing private key and security_groups
# Private key is created in ec2/keypair/privatekey/main.tf
# Setup Ubuntu vm with preinstalled packages using provisioner as "remote-exec"

provider "aws" {
  profile = "default"
  region  = local.region
}

locals {
  name   = replace(basename(path.cwd), "_", "-")
  region = "us-east-1"

  tags = {
    Project    = local.name
    GithubRepo = "https://github.com/amitkarpe/aws-tf"
  }
}

resource "aws_instance" "example" {
  key_name = data.aws_key_pair.this.key_name
  # https://cloud-images.ubuntu.com/locator/ec2/ | ap-east-1 | Ubuntu 20.04 LTS
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  # security_groups = ["example"]
  security_groups = [aws_security_group.example.name]
  root_block_device { volume_size = 50 }
  tags = {
    Name = local.name
  }
  # Any for user_data will provision new instance with same ami/data. To get its new ip run: `tf refresh`
  # user_data = "${file("webserver.sh")}"
  user_data = file("k3s.sh")
  # user_data = "curl -o- https://raw.githubusercontent.com/amitkarpe/setup/main/scripts/ubuntu.sh | bash; curl -o- https://raw.githubusercontent.com/amitkarpe/setup/main/scripts/devops.sh | bash; curl -o- https://raw.githubusercontent.com/amitkarpe/setup/main/scripts/zsh.sh | zsh"

  depends_on = [aws_security_group.example]
}

data "aws_key_pair" "this" {
  key_name           = "privatekey"
  include_public_key = true
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

# output run {
#   value = "export host=$(tf show | grep -i public_dns | awk {'print $3'} | sed 's/\"//g'); echo $host; ssh ubuntu@$host; curl -s -I $host | grep HTTP"
# }
output "ip" {
  value = aws_instance.example.public_ip
}
output "dns" {
  value = aws_instance.example.public_dns
}
output "security_group_id" {
  value = aws_security_group.example.id
}
output "security_group_name" {
  value = aws_security_group.example.name
}