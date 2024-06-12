variable "key_name" {
  description = "The name of the SSH key pair to use for the EC2 instance"
  default     = "minecraft_key"  # 키페어의 기본 이름을 설정합니다. 필요에 따라 변경할 수 있습니다.
}
