provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}
resource "aws_instance" "this" {
  ami                         = var.ami
  key_name                    = var.key_name
  availability_zone           = data.aws_subnet.this.availability_zone
  subnet_id                   = var.subnet_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.this.id]
  associate_public_ip_address = true
  # private_ip                  = var.private_ip
  iam_instance_profile        = aws_iam_instance_profile.this.name
  # iam_instance_profile        = ""

  root_block_device {
    volume_type = "gp2"
    volume_size = var.disk_size
  }

  # tags = merge(var.tags, map("Name", "vm-${var.name}"))
}


data "aws_subnet" "this" {
  id = "subnet-0f6b9adf1e7c17923"
  # id = var.subnet_id
}


# resource "aws_route53_record" "this" {
#   zone_id = var.zone_id
#   name    = "vm-${var.name}"
#   type    = "A"
#   ttl     = "300"
#   records = ["${aws_instance.this.private_ip}"]
# }