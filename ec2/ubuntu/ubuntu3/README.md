# Using inline with provisioner & remote-exec 

### Install/Configure packages using "inline"

```hcl

resource "aws_instance" "example" {
  key_name = data.aws_key_pair.this.key_name
  # https://cloud-images.ubuntu.com/locator/ec2/ | ap-east-1 | Ubuntu 20.04 LTS
  ami                         = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  security_groups = ["ubuntu-public"]
  tags = {
    Name = local.name
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/privatekey.pem")
    host = coalesce(self.public_ip, self.private_ip)
    # script_path = "ubuntu.sh"
  }

  provisioner "file" {
    source      = "scripts"
    destination = "/tmp/scripts"
  }  

# https://www.terraform.io/language/resources/provisioners/remote-exec
  provisioner "remote-exec" {
    inline = [
      "ls -lh /tmp/scripts","chmod +x /tmp/scripts/*","ls -lh /tmp/scripts","/tmp/scripts/ubuntu.sh", "/tmp/scripts/devops.sh"
    ]
  }
}
```