variable "region" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}
variable "subnets" {
  type        = list(string)
  description = "Subnet IDs"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "security_groups" {
  type        = list(string)
  description = "Security group IDs to allow access to the EFS"
}


