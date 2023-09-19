# Using scripts with provisioner & remote-exec 
## Amazon/ RedHat Linux with basic DevOps tools

### Install/Configure packages using "scripts"


```js

resource "aws_instance" "example" {
  key_name = data.aws_key_pair.this.key_name
  # https://cloud-images.ubuntu.com/locator/ec2/ | ap-east-1 | Ubuntu 20.04 LTS
  ami             = data.aws_ami.amz.id
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.example.name]

  tags = {
    Name = local.name
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/privatekey.pem")
    host        = coalesce(self.public_ip, self.private_ip)
  }

  provisioner "remote-exec" {
    scripts = ["scripts/install.sh", "scripts/devops.sh"]
  }
  depends_on = [ aws_security_group.example ]
}
```
