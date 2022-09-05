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

resource "aws_instance" "example" {
  key_name = data.aws_key_pair.this.key_name
  # https://cloud-images.ubuntu.com/locator/ec2/ | ap-east-1 | Ubuntu 20.04 LTS
   ami                         = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  security_groups = ["ubuntu-public"]
  root_block_device {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 200
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
    host = coalesce(self.public_ip, self.private_ip)
    # script_path = "ubuntu.sh"
  }

  provisioner "file" {
    source      = "scripts"
    destination = "/tmp/scripts"
  }  

# https://www.terraform.io/language/resources/provisioners/remote-exec
  provisioner "remote-exec" {
    inline = [
      "ls -lh /tmp/scripts","chmod +x /tmp/scripts/*","ls -lh /tmp/scripts","/tmp/scripts/ubuntu.sh", "/tmp/scripts/devops.sh"
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

output run {
  value = "export host=$(tf show | grep -i public_dns | awk {'print $3'} | sed 's/\"//g'); echo $host; ssh ubuntu@$host; curl -s -I $host | grep HTTP"
}
output ip {
  value = aws_instance.example.public_ip
}