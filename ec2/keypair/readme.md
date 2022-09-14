# Amazon EC2 key pairs

### Create a key pair using Amazon EC2

```
export privatekey=bastion
aws ec2 create-key-pair \
    --key-name ${privatekey} \
    --key-type rsa \
    --key-format pem \
    --query "KeyMaterial" \
    --output text > ${privatekey}.pem

mv $(basename $(pwd)).pem ~/.ssh/
```

### Create a key pair using a third-party tool and import the public key to Amazon EC2


```
export privatekey=ubuntu
ssh-keygen -t rsa -f ${privatekey}
aws ec2 import-key-pair --key-name ${privatekey} --public-key-material fileb://${privatekey}.pub

#ssh-keygen -y -f ${privatekey} >> ${privatekey}_public.pub
```

Ref:
* https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/key_pair
