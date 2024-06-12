output "instance_ip" {
  value = aws_instance.minecraft.public_ip
}

# 키 페어 생성 후 private key를 출력하여 사용할 수 있도록 함
output "private_key" {
  value = tls_private_key.minecraft.private_key_pem
  sensitive = true
}
