# Amazon EC2 key pairs

### Create a key pair using Amazon EC2

```
export key=ubuntu
aws ec2 create-key-pair \
    --key-name ${key} \
    --key-type rsa \
    --key-format pem \
    --query "KeyMaterial" \
    --output text > ${key}.pem

mv $(basename $(pwd)).pem ~/.ssh/
```

### Create a key pair using a third-party tool and import the public key to Amazon EC2


```
export key=ubuntu
ssh-keygen -t rsa -f ${key}
aws ec2 import-key-pair --key-name ${key} --public-key-material fileb://${key}.pub

#ssh-keygen -y -f ${key} >> ${key}_public.pub
```

Ref:
* https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/key_pair
