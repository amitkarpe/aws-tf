# Provision Amazon Linux using public_key from current folder.
# Test web server using public_ip and public_dns.
provider "aws" {
  profile = "default"
  # region  = "us-east-1"
  region = "us-west-2"
}

resource "aws_key_pair" "example" {
  key_name   = "mykey"
  public_key = file("extra/mykey.pub")
}

resource "aws_instance" "example" {
  key_name = aws_key_pair.example.key_name
  # ami           = "ami-0947d2ba12ee1ff75" # Amazon Linux 2 AMI (HVM), SSD Volume Type # us-east-1
  ami = "ami-038937b3d6616035f" # Amazon Linux 2 AMI (HVM), SSD Volume Type # us-west-2 
  # ami             = data.aws_ami.amz.id
  instance_type               = "t3.micro"
  vpc_security_group_ids      = ["sg-0e85c9101ffb2bedb"]
  subnet_id                   = "subnet-07b1838a7bbda16d0"
  associate_public_ip_address = true

  tags = {
    Name = "mykey"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("extra/mykey")
    host        = self.public_ip
    # host = coalesce(self.public_ip, self.private_ip)

  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
      "sudo yum -y install git wget curl htop",
    ]
  }
}


data "aws_ami" "amz" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    #  values = ["amzn-ami-hvm-*-x86_64-gp2"]  
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

output "dns" {
  value       = aws_instance.example.public_dns
  description = "export host=$(tf show | grep -i public_dns | awk {'print $3'} | sed 's/\"//g'); echo $host; ssh ec2-user@$host"
}

output "ip" {
  value       = aws_instance.example.public_ip
  description = "value = aws_instance.example.public_ip"
}

