# Provision Amazon Linux using public_key from current folder.
# Test web server using public_ip and public_dns.
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_key_pair" "example" {
  key_name   = "examplekey3"
  public_key = file("terraform.pub")
}

resource "aws_instance" "example" {
  key_name      = aws_key_pair.example.key_name
  ami           = "ami-0947d2ba12ee1ff75"
  instance_type = "t3.micro"

  tags = {
    Name = "demo3"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("terraform")
    #    host        = self.public_ip
    host = coalesce(self.public_ip, self.private_ip)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx"
    ]
  }
}

output dns {
  value       = aws_instance.example.public_dns
  description = "export host=$(tf show | grep -i public_dns | awk {'print $3'} | sed 's/\"//g'); echo $host; ssh ec2-user@$host"
}

output ip {
  value = aws_instance.example.public_ip
  description = "value = aws_instance.example.public_ip"
}

