terraform {
  required_providers {
    aws = {
    source  = "hashicorp/aws"
    version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region     = "us-east-1"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
resource "aws_db_instance" "rds_instance" {
allocated_storage = 20
identifier = "rds"
storage_type = "gp2"
engine = "mysql"
engine_version = "8.0.27"
instance_class = "db.t2.micro"
name = "test"
username = "admin"
password = "password"
publicly_accessible    = true
skip_final_snapshot    = true
# vpc_security_group_ids - (Optional) List of VPC security groups to associate.
# vpc_security_group_ids  = ["sg-07ce1dbff42cec50d"]


  tags = {
    Name = "devops-test"
  }
  lifecycle {
    ignore_changes = [password]
  }
}