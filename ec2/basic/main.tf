# Provision Amazon Linux using public_key from ~/.ssh/id_rsa.pub.
# Test mounting S3 Bucket into folder.

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_key_pair" "auth" {
  key_name   = var.name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "demo" {
  ami           = "ami-0947d2ba12ee1ff75"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.auth.key_name
  tags = {
    Name       = var.name
    Code       = "ec2/basic"
    Repository = "https://github.com/amitkarpe/aws-tf.git"
  }
  iam_instance_profile = aws_iam_instance_profile.s3_access_profile.name

}

resource "aws_s3_bucket" "demo" {
  bucket = var.bucket
  acl    = "private"
  lifecycle {
    prevent_destroy = false
    ignore_changes  = [policy]
  }
  # Added force_destroy, which is risky. It force the deletion of all objects in an S3 bucket when running terraform destroy -auto-approve
  force_destroy = true
}

# resource "aws_s3_bucket_object" "demo" {
#   bucket  = aws_s3_bucket.demo.id
#   key     = "test.txt"
#   content = "Hello, World!"
# }

resource "aws_s3_object" "demo" {
  bucket  = aws_s3_bucket.demo.id
  key     = "test.txt"  
  content = "Hello, World!"
  depends_on = [aws_s3_bucket.demo]
}

resource "null_resource" "demo" {
  # depends_on = [aws_instance.demo, aws_s3_bucket_object.demo]
  depends_on = [aws_instance.demo, aws_s3_object.demo]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = aws_instance.demo.public_ip
    }
    inline = [
      "set +e",
      "sudo amazon-linux-extras install epel -y",
      "sudo yum install -y s3fs-fuse",
      "echo '${aws_s3_bucket.demo.id} /mnt/s3 fuse.s3fs _netdev,allow_other,iam_role=auto,uid=1000,gid=1000 0 0' | sudo tee -a /etc/fstab",
      "sudo mkdir /mnt/s3",
      "sudo mount /mnt/s3",
      "sudo chown ec2-user:ec2-user /mnt/s3",
      # "sudo s3fs ${aws_s3_bucket.demo.id} /mnt/s3",
      "set -x",
      "sudo mount -v /mnt/s3 || true"
    ]
  }
}

output "ip" {
  value       = aws_instance.demo.public_ip
  description = "Public IP Address"
}

output "dns" {
  value       = aws_instance.demo.public_dns
  description = "Public DNS"
}

output "s3" {
  value       = aws_s3_bucket.demo.id
  description = "S3 Bucket"
}

output "cmd" {
  value       = "export dns=$(terraform output -json | jq -r .dns.value); ssh ec2-user@$dns"
  description = "Command"
}

resource "aws_iam_role" "s3_access_role" {
  name = "s3_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_access_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.s3_access_role.name
}

# resource "aws_instance" "demo" {
#   ami           = "ami-0947d2ba12ee1ff75"
#   instance_type = "t2.micro"
#   key_name      = aws_key_pair.auth.key_name
#   tags = {
#     Name       = var.name
#     Code       = "ec2/basic"
#     Repository = "https://github.com/amitkarpe/aws-tf.git"
#   }

#   iam_instance_profile = aws_iam_instance_profile.s3_access_profile.name
# }

resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "s3_access_profile"

  role = aws_iam_role.s3_access_role.name
}