provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "minecraft" {
  ami           = "ami-01cd4de4363ab6ee8"  # 원하는 AMI ID로 변경
  instance_type = "t3.small"               # 인스턴스 유형 선택
  key_name      = var.key_name  # EC2에서 생성한 키 페어 이름

  security_groups = [aws_security_group.minecraft.name]

  tags = {
    Name = "minecraft-server"
  }
}

resource "aws_security_group" "minecraft" {
  name        = "minecraft-security-group"
  description = "Security group for Minecraft server"

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
