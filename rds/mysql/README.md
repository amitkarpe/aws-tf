# Provision MYSQL RDS

* This module provisions a MYSQL RDS instance.

* To access MYSQL RDS instance, you need to whitelist your IP address in the security group.

```sh
# Create MYSQL RDS instance
terraform apply -target=module.rds-mysql.aws_db_instance.this

# To access MySQL Server
# brew install mysql-client

# export host=$(terraform output -raw rds_mysql_endpoint)
export host=$(terraform output -json | jq -r .db_instance.value.address)
export user=admin
export pass=password
mysql -u$user -p${pass} -h${host} -e "show databases"

# Destroy MYSQL RDS instance
terraform destroy -target=module.rds-mysql.aws_db_instance.this
```

