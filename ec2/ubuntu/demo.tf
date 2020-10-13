provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_key_pair" "example" {
  key_name   = "ubuntu"
  public_key = file("terraform.pub")
}

resource "aws_instance" "example" {
  key_name = aws_key_pair.example.key_name
  # https://cloud-images.ubuntu.com/locator/ec2/ | ap-east-1 | Ubuntu 20.04 LTS
  ami           = "ami-0dba2cb6798deb6d8"
#  instance_type = "t3.small"
  instance_type = "t3.medium"
  tags = {
    Name = "ubuntu"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("terraform")
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