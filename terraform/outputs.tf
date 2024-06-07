output "instance_ip" {
  value = aws_instance.minecraft.public_ip
}

output "security_group_id" {
  value = aws_security_group.existing_security_group.id
}
