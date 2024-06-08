provider "aws" {
  region = "us-west-2"
}

# 기존 보안 그룹을 데이터 소스로 가져옴
data "aws_security_group" "existing" {
  name = "MineCraft"
}

# 새로운 보안 그룹 생성
resource "aws_security_group" "minecraft" {
  count       = length(data.aws_security_group.existing) == 0 ? 1 : 0
  name        = "MineCraft"
  description = "Security group for Minecraft server"
  vpc_id      = "vpc-03d794f6b57f97142"  # 원하는 VPC의 ID를 여기에 지정합니다.

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
}

# EC2 인스턴스 생성
resource "aws_instance" "minecraft" {
  ami           = "ami-01cd4de4363ab6ee8"
  instance_type = "t3.small"
  key_name      = "lab6"
  availability_zone = "us-west-2a"  # 원하는 가용 영역을 여기에 지정합니다.
  subnet_id     = "subnet-0dc899575612c8714"  # 원하는 서브넷의 ID를 여기에 지정합니다.

  # 보안 그룹을 인스턴스에 할당
  vpc_security_group_ids = length(data.aws_security_group.existing) == 0 ? [aws_security_group.minecraft[0].id] : [data.aws_security_group.existing.id]

  tags = {
    Name = "MinecraftServer"
  }

  lifecycle {
    prevent_destroy = true  # 인스턴스를 삭제하지 않도록 설정
  }
}
