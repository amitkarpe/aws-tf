# Ubuntu with K3S [Kubernetes Cluster] https://k3s.io/
# Here we are usin provisioner as "local-exec" to download the script from github and then execute it on remote machine
# Setup k3s (Kubernetes Cluster) on Ubuntu 20.04 LTS

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

resource "aws_instance" "example" {
  key_name = data.aws_key_pair.this.key_name
  # https://cloud-images.ubuntu.com/locator/ec2/ | ap-east-1 | Ubuntu 20.04 LTS
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  # security_groups = ["ubuntu-public2"]
  security_groups = [aws_security_group.example.name]
  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    throughput  = 200
    volume_size = 50
    tags = {
      Name = "my-root-block"
    }
  }
  tags = {
    Name = local.name
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/privatekey.pem")
    host        = coalesce(self.public_ip, self.private_ip)
  }

  provisioner "local-exec" {
    command = "curl -s -o scripts/k3s.sh https://raw.githubusercontent.com/amitkarpe/setup/main/scripts/k3s.sh;"
  }

  provisioner "remote-exec" {
    scripts = ["scripts/k3s.sh"]
  }

  # provisioner "local-exec" {
  #   command = "curl -s -o scripts/install.sh https://raw.githubusercontent.com/amitkarpe/setup/main/scripts/install.sh; curl -s -o scripts/devops.sh https://raw.githubusercontent.com/amitkarpe/setup/main/scripts/devops.sh"
  # }
  # provisioner "remote-exec" {
  #   scripts = ["scripts/install.sh", "scripts/devops.sh"]
  # }
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

output "run" {
  value = "export host=$(tf show | grep -i public_dns | awk {'print $3'} | sed 's/\"//g'); echo $host; ssh ubuntu@$host; curl -s -I $host | grep HTTP"
}

output "ip" {
  value = aws_instance.example.public_ip
}
