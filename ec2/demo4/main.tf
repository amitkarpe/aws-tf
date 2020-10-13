provider "aws" {
  region  = "us-east-1"
  version = "~> 3.0"

}

resource "aws_instance" "web" {
  ami           = "ami-0947d2ba12ee1ff75"
  instance_type = "t2.micro"
  key_name = "amit"
  security_groups= [aws_security_group.web.name]
  tags = {
    "Name" = "web1"
  }

}

resource "aws_security_group" "web"{
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
    Name = "allow_tls"
  }
}

output "dns" {
  value = aws_instance.web.public_dns
}