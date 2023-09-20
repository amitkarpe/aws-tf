#!/bin/bash

echo "Make sure you added your IP Address into default Security Group (SSH Port)"
read
echo "Provision ec2 instance with Amazon Linux using already created private & public key from ~/.ssh folder."
read
echo "Going to provison AWS keypair using existing key."

echo "Provosion now."

echo ""
echo ""
set -x
terraform apply -auto-approve
echo ""
echo ""
echo "Test ssh server using public_ip and public_dns."
echo ""
echo ""
export dns=$(terraform output -json | jq -r .dns.value); echo $dns
ssh ec2-user@$dns "hostname"
set +x
echo ""
echo ""



