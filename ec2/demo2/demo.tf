provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_key_pair" "example" {
  key_name   = "examplekey"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "example" {
  key_name      = "aws_key_pair.example.key_name"
  ami           = "ami-0947d2ba12ee1ff75"
#  ami           = "ami-04590e7389a6e577c"
  instance_type = "m4.large"

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
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

