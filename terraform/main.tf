provider "aws" {
  region = "us-west-2"
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

data "aws_security_group" "existing" {
  id = "sg-0f22cfa2e6de7ffe6"  # 기존 보안 그룹의 ID 사용
}

resource "aws_instance" "minecraft" {
  ami           = "ami-01cd4de4363ab6ee8"
  instance_type = "t3.small"
  key_name      = "lab6"
  security_groups = length(data.aws_security_group.existing) == 0 ? [aws_security_group.minecraft.name] : [data.aws_security_group.existing.id]

  tags = {
    Name = "MinecraftServer"
  }

  lifecycle {
    prevent_destroy = true  # 인스턴스를 삭제하지 않도록 설정
  }
}
