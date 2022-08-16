provider "aws" {
  region     = "us-east-1"
  version = "4.10"
}

resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucketmy-tf-test-bucmy-tf-test-bucketmy-tf-test-bucketmy-tf-test-bucketket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}

output name {
  value       = aws_s3_bucket.b.bucket
  description = "bucket name"
}
