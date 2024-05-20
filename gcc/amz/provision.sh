#!/bin/bash

echo "Make sure you added your IP Address into default Security Group (SSH Port)"
read
echo "Provision ec2 instance with Amazon Linux using newly created private & public key from current folder."
read

echo "Create new key, using create-key.sh script."

bash create-key.sh

echo "Going to provison AWS keypair using newly created key."
echo "Provosion now."

terraform apply -auto-approve


echo "Test web server using public_ip and public_dns."
IP=$(terraform output -json | jq -r .ip.value); echo $IP
#ssh ec2-user@${IP} -i mykey "hostname"

echo "Make sure you added your IP Address into default Security Group (HTTP Port)"
curl -I ${IP}