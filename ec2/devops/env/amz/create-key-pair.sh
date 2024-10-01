#!/bin/bash
KEY_NAME="bastion_public_key"
REGION="ap-southeast-1"
aws ec2 create-key-pair \
--key-name $KEY_NAME \
--query 'KeyMaterial' \
--output text > ${KEY_NAME}.pem
chmod 400 ${KEY_NAME}.pem
mv -v ${KEY_NAME}.pem ~/.ssh/
