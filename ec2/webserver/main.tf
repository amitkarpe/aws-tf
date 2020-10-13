provider "aws" {
  region  = "us-east-1"
  version = "~> 3.0"

}
resource "aws_key_pair" "example" {
  key_name   = "demo4"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "web" {
  key_name = aws_key_pair.example.key_name
  #  key_name = "amit"
  ami             = "ami-0947d2ba12ee1ff75"
  instance_type   = "t3.medium"
  security_groups = [aws_security_group.web.name]
  tags = {
    "Name" = "demo4"
    "env"  = "webserver"
  }
}

resource "aws_security_group" "web" {
  name        = "websg"
  description = "web allow"

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-SG"
  }
}

output dns {
  value       = aws_instance.web.public_dns
  description = "export host=$(tf show | grep -i public_dns | awk {'print $3'} | sed 's/\"//g'); echo $host; ssh ec2-user@$host"
}