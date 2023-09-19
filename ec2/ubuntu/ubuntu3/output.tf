
output ip {
  value = aws_instance.example.public_ip
}

output dns {
  value = aws_instance.example.public_dns
}

output "security_group_id" {
  value = aws_security_group.example.id
}

output "security_group_name" {
  value = aws_security_group.example.name
}