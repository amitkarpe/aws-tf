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
   ami                         = data.aws_ami.ubuntu.id
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