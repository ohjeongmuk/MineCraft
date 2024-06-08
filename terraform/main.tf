# VPC 설정
resource "aws_vpc" "minecraft_vpc" {
  cidr_block = "10.0.0.0/16" # 사용 가능한 CIDR 블록 선택
}

# 서브넷 설정
resource "aws_subnet" "minecraft_subnet" {
  vpc_id            = aws_vpc.minecraft_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a" # 원하는 가용성 영역 선택
}

# 보안 그룹 설정 (기존 보안 그룹 사용)
data "aws_security_group" "existing" {
  name = "MineCraft" # 기존 보안 그룹 이름
}

# Minecraft 인스턴스 설정
resource "aws_instance" "minecraft" {
  ami           = "ami-01cd4de4363ab6ee8" # 사용할 AMI 선택
  instance_type = "t3.small" # 원하는 인스턴스 유형 선택
  key_name      = "lab6" # SSH 키 이름
  subnet_id     = aws_subnet.minecraft_subnet.id

  tags = {
    Name = "MinecraftServer"
  }

  lifecycle {
    prevent_destroy = true # 인스턴스 삭제 방지
  }
}
