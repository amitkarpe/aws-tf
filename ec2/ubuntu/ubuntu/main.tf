provider "aws" {
  region = local.region
}

locals {
  name   = "${replace(basename(path.cwd), "_", "-")}"
  region  = "us-east-1"

  tags = {
    Project    = local.name
    GithubRepo = "https://github.com/amitkarpe/aws-tf"
  }
}

resource "aws_instance" "example" {
  key_name = data.aws_key_pair.this.key_name
  # https://cloud-images.ubuntu.com/locator/ec2/ | ap-east-1 | Ubuntu 20.04 LTS
   ami                         = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  security_groups = ["ubuntu-public"]
  tags = {
    Name = local.name
  }
  user_data = "${file("init.sh")}"
  # user_data = "curl -o- https://raw.githubusercontent.com/amitkarpe/setup/main/ubuntu.sh | bash; curl -o- https://raw.githubusercontent.com/amitkarpe/setup/main/devops.sh | bash; curl -o- https://raw.githubusercontent.com/amitkarpe/setup/main/zsh2.sh | zsh"
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

output run {
  value = "export host=$(tf show | grep -i public_dns | awk {'print $3'} | sed 's/\"//g'); echo $host; ssh ubuntu@$host; curl -s -I $host | grep HTTP"
}
output ip {
  value = aws_instance.example.public_ip
}