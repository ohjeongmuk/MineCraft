provider "aws" {
  region = "us-west-2"
}

# TLS 키 페어 생성
resource "tls_private_key" "minecraft" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# AWS 키 페어 생성
resource "aws_key_pair" "minecraft" {
  key_name   = "minecraft-key"
  public_key = tls_private_key.minecraft.public_key_openssh
}

# 새로운 보안 그룹 생성
resource "aws_security_group" "minecraft" {
  name        = "MineCraft"
  description = "Security group for Minecraft server"
  vpc_id      = "vpc-04000ec46e8d965c0"  # 원하는 VPC의 ID를 여기에 지정합니다.

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
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

}



# EC2 인스턴스 생성
resource "aws_instance" "minecraft" {
  ami           = "ami-01cd4de4363ab6ee8"
  instance_type = "t3.small"
  key_name      = aws_key_pair.minecraft.key_name  # 새로 생성된 키 페어 사용
  availability_zone = "us-west-2a"  # 원하는 가용 영역을 여기에 지정합니다.
  subnet_id     = "subnet-0014adfa681df4606"  # 원하는 서브넷의 ID를 여기에 지정합니다.

  # 보안 그룹을 인스턴스에 할당
  vpc_security_group_ids = [aws_security_group.minecraft.id]

  tags = {
    Name = "MineCraft-Server"
  }

  lifecycle {
    prevent_destroy = true  # 인스턴스를 삭제하지 않도록 설정
  }
}

