provider "aws" {}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  # version = "2.77.0"

  name                 = "education"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_security_group" "rds" {
  name   = "education_rds"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "education_rds"
  }
}

resource "aws_db_subnet_group" "education" {
  name       = "education2"
  # subnet_ids = module.vpc.public_subnets
  # subnet_ids = [module.vpc.public_subnets[0], module.vpc.public_subnets[1], module.vpc.public_subnets[2]]
  subnet_ids = [module.vpc.public_subnets[0], module.vpc.public_subnets[1] ]

  tags = {
    Name = "Education"
  }
}

resource "aws_db_parameter_group" "education" {
  name = "education2"
  # aws rds describe-db-engine-versions --engine mysql | grep DBParameterGroupFamily
  family = "mysql5.7"
}

resource "aws_db_instance" "education" {
  identifier             = "education"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7"
  username               = "edu"
  # password               = var.db_password
  # export TF_VAR_db_password="password"
  password               = "password"
  db_subnet_group_name   = aws_db_subnet_group.education.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.education.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}
