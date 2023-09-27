provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "windows" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my-key-pair"
  user_data     = <<-EOF
    <powershell>
    # Install S3FS
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Module -Name S3FS -Force

    # Mount S3 bucket
    $accessKey = "ACCESS_KEY"
    $secretKey = "SECRET_KEY"
    $bucketName = "BUCKET_NAME"
    $mountPath = "C:\s3"

    $s3fsOptions = @{
      AccessKey = $accessKey
      SecretKey = $secretKey
      BucketName = $bucketName
      MountPath = $mountPath
    }

    New-S3FSMount @s3fsOptions
    </powershell>
  EOF

  tags = {
    Name = "windows-instance"
  }
}

resource "aws_security_group" "windows" {
  name_prefix = "windows-sg-"
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface_security_group_attachment" "windows" {
  security_group_id    = aws_security_group.windows.id
  network_interface_id = aws_instance.windows.network_interface_id
}

output "public_ip" {
  value = aws_instance.windows.public_ip
}

output "rdp_command" {
  value = "mstsc /v:${aws_instance.windows.public_ip}"
}