Use following command:


```
####
#   Usage:
#   ssh -i <path to key.pem>" -f -l <user> -N -L <port>:<RDS Endpoint>:<local port> <bastion host> -v
###

export rds=dna-dna.cluster-ro-cjlrkpc87cgl.us-east-1.rds.amazonaws.com
export bastion=ec2-54-221-58-209.compute-1.amazonaws.com
ssh -N -L 3306:${rds}:3306 ${bastion} -i ~/.ssh/bastion_public_key.pem -v
```

And in other terminal tab:

```
export user='root'
export pass='password'
export host="127.0.0.1"
mysql -u${user} -p${pass} -h${host} -e "show databases"
```
