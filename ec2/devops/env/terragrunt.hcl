remote_state {
  backend = "s3"
  config = {
    bucket = "demo-devops-123456"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "my-lock-table"
  }
}
