# Setup bastion host to access mysql-aurora

* [bastion host code](https://github.com/amitkarpe/aws-tf/tree/master/ec2/bastion/amz-tg)
* Setup / Add following lines into “~/.ssh/config”
```
Host rds
        HostName <bastion host >
        User ec2-user
        Localforward 3306 <RDS end point>:3306
        IdentityFile ~/.ssh/bastion_public_key.pem
```

* Create ~/.ssh/bastion_public_key.pem file with private key value for bastion host 
* Set correct permissions for ~/.ssh/bastion_public_key.pem and ~/.ssh/config:

```
chmod 644 ~/.ssh/config
chmod 600 ~/.ssh/bastion_public_key.pem
```

* Confirm whether you can access rds (i.e. bastion host) using ssh. Keep running this session in one terminal, which is our active tunnel used by mysql to connect to RDS Cluster.
```
ssh rds
```

Run following command to connect RDS:
```
export user='root'
export pass='password'
export host="127.0.0.1"
mysql -u${user} -p${pass} -h${host} -e "show databases"
```

Ref:
[SSH tunneling to access AWS RDS using Bastion](https://marcincuber.medium.com/ssh-tunneling-to-access-aws-rds-using-bastion-host-and-iam-role-a0610104bb6c)
[Amazon RDS DB instance using a bastion host ](https://aws.amazon.com/premiumsupport/knowledge-center/rds-connect-using-bastion-host-linux/)