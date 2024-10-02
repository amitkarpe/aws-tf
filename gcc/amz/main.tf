# Provision Amazon Linux using public_key from current folder.
# Test web server using public_ip and public_dns.
provider "aws" {
#  profile = "default"
  region  = "ap-southeast-1"
}

# resource "aws_key_pair" "example" {
#   key_name   = "mykey"
#   public_key = file("mykey.pub")
# }

resource "aws_instance" "example" {
#  key_name      = aws_key_pair.example.key_name
  key_name      = "amit"
  # ami           = "ami-004c463c8207b4dfa"
  associate_public_ip_address = true
  ami           = "ami-0b58cb2116e0ff56b" # Test9-install-mongodb
  # ami           = "ami-0158c3e2b8ff27ad9" # Test7-snapshot_users
  # TESTing
  instance_type = "t3.small"
  subnet_id     = "subnet-0d13ba2dcbb0f6d46"
  availability_zone = "ap-southeast-1b"
  # If no default VPC then check [docs](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build#troubleshooting)
  # vpc_security_group_ids  = ["sg-0277a736dda5e4a3f","sg-0bf11bba2384c420c"]
  vpc_security_group_ids  = ["sg-0bf11bba2384c420c"]
  # security_groups = ["sg-0277a736dda5e4a3f"]  #   EC2-Classic and default VPC only

  tags = {
    Name = "demo1"
  }

/*
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/amit.pem")
    #    host        = self.public_ip
    host = coalesce(self.public_ip, self.private_ip)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx --now"
    ]
  }
*/  
}

output dns {
  value       = aws_instance.example.public_dns
  description = "export host=$(tf show | grep -i public_dns | awk {'print $3'} | sed 's/\"//g'); echo $host; ssh ec2-user@$host"
}

output ip {
  value = aws_instance.example.public_ip
  description = "value = aws_instance.example.public_ip"
}

# aws ec2 describe-security-groups --filters Name=group-name,Values=default Name=vpc-id,Values=vpc-035eb12babd9ca798