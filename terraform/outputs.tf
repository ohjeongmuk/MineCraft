output "instance_ip" {
  value = data.aws_instance.minecraft.public_ip
}

output "security_group_id" {
  value = data.aws_security_group.existing_security_group.id
}
