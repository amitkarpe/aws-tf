# Ubuntu with basic tools using provisioner "local-exec" and "remote-exec"
# Test various tools version for two AWS instanes
# IP=$(terraform output -json | jq -r .ip.value); echo $IP; ssh ubuntu@$IP -i ~/.ssh/privatekey.pem
# nvm version; node -v; npm version

provider "aws" {
  region  = local.region
  profile = "default"
}

locals {
  name   = replace(basename(path.cwd), "_", "-")
  region = "us-east-1"

  tags = {
    Project    = local.name
    GithubRepo = "terraform-aws-key-pair"
    GithubOrg  = "terraform-aws-modules"
  }
}


# Provision a aws instance

resource "aws_instance" "example" {
  key_name = data.aws_key_pair.this.key_name
  # https://cloud-images.ubuntu.com/locator/ec2/ | ap-east-1 | Ubuntu 20.04 LTS
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t3.medium"
  security_groups = [aws_security_group.example.name]

  tags = {
    Name = local.name
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/privatekey.pem")
    host        = coalesce(self.public_ip, self.private_ip)
    # script_path = "ubuntu.sh"
  }

  provisioner "file" {
    source      = "scripts"
    destination = "/tmp/scripts"
  }

  # https://www.terraform.io/language/resources/provisioners/remote-exec
  provisioner "local-exec" {
    command = "curl -s -o scripts/install.sh https://raw.githubusercontent.com/amitkarpe/setup/main/scripts/install.sh;"
  }
  provisioner "remote-exec" {
    inline = [
      "ls -lh /tmp/scripts", "chmod +x /tmp/scripts/*", "ls -lh /tmp/scripts", "/tmp/scripts/install.sh"
    ]
  }
}

# Provision a aws instance

resource "aws_instance" "example2" {
  key_name = data.aws_key_pair.this.key_name
  # https://cloud-images.ubuntu.com/locator/ec2/ | ap-east-1 | Ubuntu 20.04 LTS
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t3.medium"
  security_groups = [aws_security_group.example.name]

  tags = {
    Name = "${local.name}-2"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/privatekey.pem")
    host        = coalesce(self.public_ip, self.private_ip)
    # script_path = "ubuntu.sh"
  }

  provisioner "file" {
    source      = "scripts"
    destination = "/tmp/scripts"
  }

  # https://www.terraform.io/language/resources/provisioners/remote-exec
  provisioner "local-exec" {
    command = "curl -s -o scripts/install.sh https://raw.githubusercontent.com/amitkarpe/setup/main/scripts/install.sh;"
  }
  provisioner "remote-exec" {
    inline = [
      "ls -lh /tmp/scripts", "chmod +x /tmp/scripts/*", "ls -lh /tmp/scripts", "/tmp/scripts/install.sh"
    ]
  }
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

