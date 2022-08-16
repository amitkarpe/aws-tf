provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

# Create security groups 
resource "aws_security_group" "this" {
  name   = "sg_${var.name}"
  vpc_id = var.vpc_id
  # Jumphost
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = var.jumphost_ip
  }
  # EGRESS
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, var.additional_tags)
}

data "aws_subnet" "this" {
  id = var.subnet_id
}

resource "aws_iam_role" "this" {
  name                 = "iamr-${var.name}"
  assume_role_policy   = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "Allow",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      }     
    }
  ]
}
POLICY

  tags = {
    Custom-tag = "iamr-${var.name}"
    Project    = "demo"
  }
}


resource "aws_iam_role_policy" "this" {
  name       = "irp-${var.name}"
  role       = aws_iam_role.this.id
  depends_on = [aws_iam_role.this]

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "s3:ListBucket"
          ],
          "Resource": "*"
        }
    ]
}
EOF

}

resource "aws_iam_instance_profile" "this" {
  name = "iamip-${var.name}"
  role = aws_iam_role.this.name
}



resource "aws_instance" "this" {
  ami                         = var.ami
  key_name                    = var.key_name
  availability_zone           = data.aws_subnet.this.availability_zone
  subnet_id                   = var.subnet_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.this.id]
  associate_public_ip_address = false
  # private_ip                  = var.private_ip
  iam_instance_profile        = aws_iam_instance_profile.this.name

  root_block_device {
    volume_type = "gp2"
    volume_size = var.disk_size
  }

  # tags = merge(var.tags, map("Name", "vm-${var.name}"))
}

# resource "aws_route53_record" "this" {
#   zone_id = var.zone_id
#   name    = "vm-${var.name}"
#   type    = "A"
#   ttl     = "300"
#   records = ["${aws_instance.this.private_ip}"]
# }