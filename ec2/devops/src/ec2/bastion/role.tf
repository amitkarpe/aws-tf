# Role
resource "aws_iam_role" "this" {
  name                 = "iamr-${var.name}"
  assume_role_policy   = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "Allow",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      }     
    }
  ]
}
POLICY

  tags = {
    Custom-tag = "iamr-${var.name}"
    Project    = "demo"
  }
}


resource "aws_iam_role_policy" "this" {
  name       = "irp-${var.name}"
  role       = aws_iam_role.this.id
  depends_on = [aws_iam_role.this]

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "s3:ListBucket"
          ],
          "Resource": "*"
        }
    ]
}
EOF

}

resource "aws_iam_instance_profile" "this" {
  name = "iamip-${var.name}"
  role = aws_iam_role.this.name
}