provider "aws" {
  region = "us-west-2"
}

data "aws_security_group" "existing" {
  id = "sg-0f22cfa2e6de7ffe6"  # 기존 보안 그룹의 ID 사용
}

resource "aws_instance" "minecraft" {
  ami           = "ami-01cd4de4363ab6ee8"
  instance_type = "t3.small"
  key_name      = "lab6"
  security_groups = [data.aws_security_group.existing.id]

  tags = {
    Name = "MinecraftServer"
  }

  lifecycle {
    prevent_destroy = true  # 인스턴스를 삭제하지 않도록 설정
  }
}
