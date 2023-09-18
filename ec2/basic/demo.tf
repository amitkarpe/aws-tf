provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}
resource "aws_key_pair" "auth" {
	key_name = "tf"
	public_key = file(var.public_key_path)
}
 
resource "aws_instance" "demo" {
  ami           = "ami-0947d2ba12ee1ff75"
  instance_type = "t2.micro"
  key_name = aws_key_pair.auth.key_name
  tags = {
    Name = "demo1"
  }
}

output ip {
  value       = aws_instance.demo.public_ip
  description = "Public IP Address"
}

output dns {
  value       = aws_instance.demo.public_dns
  description = "Public DNS"
}
output name {
  value       = "export host=$(tf show | grep -i public_dns | awk {'print $3'} | sed 's/\"//g'); echo $host"
  description = "Commands"
}
