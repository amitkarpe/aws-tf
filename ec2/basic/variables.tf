variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  default = "~/.ssh/id_rsa"
}

variable "bucket" {
  default = "amitkarpe1234567"
}

# BUCKET_NAME="amitkarpe1234567"
# REGION="ap-southeast-1"
# aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION --create-bucket-configuration LocationConstraint=$REGION

variable "name" {
  default = "basic"
}