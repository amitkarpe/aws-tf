terraform {
  required_providers {
    aws = {
    source  = "hashicorp/aws"
    version = "~> 4.12"
    }
  }
  required_version = ">= 0.14.9"
}
data "aws_vpc" "default" {
  default = true
} 
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# data "aws_vpc" "selected" {
#   id = var.vpc_id
# }

locals {
  name   = "${replace(basename(path.cwd), "_", "-")}"
  region = "us-east-1"
  tags = {
    Owner       = "DevOps"
    Environment = "dev"
  }
}

module "cluster" {
  source  = "terraform-aws-modules/rds-aurora/aws"

  name              = "${local.name}"
  database_name     = "testdb"
  engine            = "aurora-mysql"
  engine_mode       = "serverless"
  storage_encrypted = true
  master_password   = "password"

  vpc_id                = data.aws_vpc.default.id
  publicly_accessible = true
  # allowed_security_groups = ["sg-07ce1dbff42cec50d"]
  # vpc_security_group_ids  = ["sg-07ce1dbff42cec50d"]
  allowed_cidr_blocks     = ["0.0.0.0/0"]
  # create_security_group = true
  # allowed_cidr_blocks   = module.vpc.private_subnets_cidr_blocks



  # monitoring_interval = 60
  backup_retention_period = 1
  create_db_subnet_group = false
  create_monitoring_role = false
  create_random_password = false

  apply_immediately   = true
  skip_final_snapshot = true

  # db_parameter_group_name         = "default"
  # db_cluster_parameter_group_name = "default"
  # db_parameter_group_name         = aws_db_parameter_group.example_mysql.id
  # db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.example_mysql.id
  # enabled_cloudwatch_logs_exports = # NOT SUPPORTED

  scaling_configuration = {
    auto_pause               = true
    min_capacity             = 4
    max_capacity             = 16
    seconds_until_auto_pause = 600
    timeout_action           = "ForceApplyCapacityChange"
  }
}

# output "db_instance_password" {
#   description = "The master password"
#   # value       = try(aws_db_instance.this[0].password, "")
#   value       = try(aws_rds_cluster.this[0].master_password, "")
#   sensitive   = true
# }

# output "mysql_cluster_master_password" {
#   description = "The database master password"
#   value       = module.cluster.master_password
#   sensitive   = true
# }
