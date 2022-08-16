# output "hostname" {
#   value = aws_route53_record.this.name
# }

output "instanceid" {
  value = aws_instance.this.id
}

output "dns" {
  value = aws_instance.this.public_dns
}

output "instanceip" {
  value = aws_instance.this.private_ip
}

output "security_group" {
  value = aws_security_group.this.id
}