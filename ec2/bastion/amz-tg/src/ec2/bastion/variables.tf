variable "aws_region" {
  default = "ap-southeast-1"
  type    = string
}

variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

# variable "zone_id" {
#   type = string
# }

variable "jumphost_ip" {
  type = list(string)
}

variable "key_name" {
  type = string
}

variable "ami" {
  type = string
}

variable "subnet_id" {
  type = string
  # default = "subnet-0a47d8c01f452adf0"
}

variable "instance_type" {
  default = "t3.medium"
  type    = string
}

variable "disk_size" {
  default = "50"
  type    = string
}

# variable "private_ip" {
#   type = string
# }

variable "aws_accountid" {
  type    = string
}


variable "tags" {
  description = "inherited tags to include"
  default     = {}
  type        = map(string)
}

variable "additional_tags" {
  description = "Additional tags to include"
  default     = {}
  type        = map(string)
}
