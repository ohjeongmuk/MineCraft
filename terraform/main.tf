provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "minecraft" {
  name        = "minecraft-security-group"
  description = "Security group for Minecraft server"

  // SSH 및 Minecraft 포트에 대한 인바운드 규칙 추가
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // 모든 트래픽에 대한 아웃바운드 규칙 추가
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
