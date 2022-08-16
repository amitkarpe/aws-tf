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

# provider "aws" {
#   region     = "us-east-1"
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
  engine_version    = "8.0.mysql_aurora.3.02.0"
  engine_mode       = "provisioned"
  storage_encrypted = true
  # export TF_VAR_db_password='password'
  master_password   = var.db_password


  # vpc_id                = data.aws_vpc.default.vpc_id
  # subnets               = data.aws_subnets.default.ids
  # vpc_id                = data.aws_vpc.default.vpc_id
  # subnets               = data.aws_subnets.default.ids
  # allowed_cidr_blocks   = module.vpc.private_subnets_cidr_blocks
  # vpc_id  = "vpc-0151c3fad1e40081f"
  # subnets = ["subnet-12345678", "subnet-87654321"]
  create_security_group = true
  publicly_accessible = true
  allowed_cidr_blocks     = ["0.0.0.0/0"]


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

  serverlessv2_scaling_configuration = {
    min_capacity = 1
    max_capacity = 3
  }

  instance_class = "db.serverless"
  instances = {
    one = {}
    # two = {}
  }
}

# Either set TF_VAR_db_password or provide password when prompted 
variable "db_password" {
  description = "RDS root user password"
  sensitive   = true
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

output "host" {
  description = "The cluster host"
  value       = module.cluster.cluster_endpoint
}
