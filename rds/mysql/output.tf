output "db_instance" {
  value = {
    id = aws_db_instance.rds_instance.id
    address = aws_db_instance.rds_instance.address
    instance_class = aws_db_instance.rds_instance.instance_class
    engine = aws_db_instance.rds_instance.engine
    engine_version = aws_db_instance.rds_instance.engine_version
    username = aws_db_instance.rds_instance.username
  }
}