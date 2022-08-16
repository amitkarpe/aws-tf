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