provider "aws" {
  profile = "default"
  region  = "us-east-1"
  }

resource "aws_key_pair" "example" {
  key_name   = "examplekey3"
  public_key = file("~/.ssh/terraform.pub")
}

resource "aws_instance" "example" {
  key_name      = aws_key_pair.example.key_name
  ami           = "ami-0947d2ba12ee1ff75"
  instance_type = "t3.medium"

  tags = {
    Name = "demo3"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/terraform")
    host        = self.public_ip
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
  sensitive   = true
  description = "export host=$(tf show | grep -i public_dns | awk {'print $3'} | sed 's/\"//g'); echo $host; ssh ec2-user@$host"
  depends_on  = []
}

