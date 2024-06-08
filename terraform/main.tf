provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "minecraft" {
  name = "MineCraft"
  description = "Security group for Minecraft server"

  ingress {
    from_port = 25565
    to_port = 25565
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "minecraft" {
  ami = "ami-01cd4de4363ab6ee8"
  instance_type = "t3.small"
  key_name = "lab6"
  availability_zone = "us-west-2a" # 여기서 원하는 AZ를 지정합니다.
  subnet_id = "subnet-0dc899575612c8714"

  tags = {
    Name = "MinecraftServer"
  }

  lifecycle {
    prevent_destroy = true # 인스턴스를 삭제하지 않도록 설정
  }
}
