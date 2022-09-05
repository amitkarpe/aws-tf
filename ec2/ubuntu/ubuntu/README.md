# Using user_data

### Install/Configure packages using "user_data"

```terraform
resource "aws_instance" "example" {
  key_name = data.aws_key_pair.this.key_name
  ami                         = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  security_groups = ["ubuntu-public"]
  tags = {
    Name = local.name
  }
  user_data = "${file("init.sh")}"
}
```

### Using inline for "user_data"

```
  user_data = "curl -o- https://raw.githubusercontent.com/amitkarpe/setup/main/ubuntu.sh | bash; curl -o- https://raw.githubusercontent.com/amitkarpe/setup/main/devops.sh | bash; 
```

### Logs and scripts path for user_data

```shell

sudo tailf /var/log/cloud-init-output.log

sudo cat /var/lib/cloud/instance/scripts/part-001

```