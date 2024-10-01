# DevOps Server

This project uses Terraform and Terragrunt to provision an Amazon Linux 2 EC2 instance in the Singapore region with various DevOps tools installed.

## Project Structure

```
ec2/devops/
├── env/
│ └── amz/
│ └── terragrunt.hcl
├── src/
│ └── ec2/
│ └── bastion/
│ ├── main.tf
│ └── variables.tf
└── README.md
```

- `env/`: Contains live environment configurations
- `src/`: Contains reusable Terraform modules

## Prerequisites

1. AWS CLI installed and configured
2. Terraform installed
3. Terragrunt installed

## Setup

### 1. Configure AWS CLI

Ensure your AWS CLI is configured with the correct credentials:

```bash
cat ~/.aws/credentials
aws sts get-caller-identity --profile default
```

### 2. Get AWS Account ID

```bash
aws sts get-caller-identity --query "Account" --output text
```

### 3. Get VPC ID

```bash
aws ec2 describe-vpcs --query "Vpcs[].VpcId" --output text
```

### 4. Get latest Amazon Linux 2 AMI ID

```bash
aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --region ap-southeast-1 --query "Parameters[0].Value" --output text
```
### 5. Create S3 bucket for Terraform state

Create a file named `create-bucket.sh` with the following content:

```bash
#!/bin/bash
BUCKET_NAME="demo-devops-123456"
REGION="ap-southeast-1"
aws s3api create-bucket \
--bucket $BUCKET_NAME \
--region $REGION \
--create-bucket-configuration LocationConstraint=$REGION
aws s3api put-bucket-versioning \
--bucket $BUCKET_NAME \
--versioning-configuration Status=Enabled
aws s3api put-bucket-encryption \
--bucket $BUCKET_NAME \
--server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'
```

Run the script:

```bash
chmod +x create-bucket.sh
./create-bucket.sh
```

### 6. Create EC2 key pair

Create a file named `create-key-pair.sh` with the following content:


```bash
#!/bin/bash
KEY_NAME="bastion_public_key"
REGION="ap-southeast-1"
aws ec2 create-key-pair \
--key-name $KEY_NAME \
--query 'KeyMaterial' \
--output text > ${KEY_NAME}.pem
chmod 400 ${KEY_NAME}.pem
```

Run the script:
```bash
chmod +x create-key-pair.sh
./create-key-pair.sh
```
Move the created key to the `.ssh` folder:

```bash
mv bastion_public_key.pem ~/.ssh/
```

## Usage

1. Navigate to the environment directory:
   ```
   cd ec2/devops/env/amz
   ```

2. Initialize Terragrunt:
   ```
   terragrunt init
   ```

3. Apply the changes:
   ```
   terragrunt apply
   ```

4. After applying, you can view the outputs:
   ```
   terragrunt output
   ```

5. SSH into the created instance:
   ```
   ssh ec2-user@<instance_ip> -i ~/.ssh/bastion_public_key.pem
   ```

   Replace `<instance_ip>` with the actual IP address from the output.

## Cleanup

To destroy the resources:

```bash
terragrunt destroy
```

## Note

- Ensure that you have the necessary IAM permissions to create and manage the required AWS resources.
- The current setup doesn't install DevOps tools automatically. You may need to modify the Terraform configuration to include user data scripts for installing the required tools.
- Always follow AWS best practices for security when setting up your infrastructure.




