provider "aws" {
  region  = "us-east-1"
}

data "aws_key_pair" "this" {
  key_name           = "privatekey"
  include_public_key = true
}

resource "aws_instance" "example" {
  key_name = data.aws_key_pair.this.key_name
  # https://cloud-images.ubuntu.com/locator/ec2/ | ap-east-1 | Ubuntu 20.04 LTS
  # ami           = "ami-0dba2cb6798deb6d8"
  ami = "ami-079ca844e323047c2"
#  instance_type = "t3.small"
  instance_type = "t3.medium"
  security_groups = ["ubuntu-public"]
  tags = {
    Name = "ubuntu2"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/privatekey.pem")
    host = coalesce(self.public_ip, self.private_ip)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update", 
      "sudo apt-get -y install nginx",
      "sudo service nginx start"
    ]
  }
}

output run {
  value = "export host=$(tf show | grep -i public_dns | awk {'print $3'} | sed 's/\"//g'); echo $host; ssh ubuntu@$host; curl -s -I $host | grep HTTP"
}
output ip {
  value = aws_instance.example.public_ip
}