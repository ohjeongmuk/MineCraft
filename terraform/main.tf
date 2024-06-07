provider "aws" {
  region = "us-west-2"
}

# "<Provider>_<type>" "<name>" => 생성
resource "aws_instance" "minecraft" {
  ami           = "ami-01cd4de4363ab6ee8"  # 사용할 AMI ID로 변경
  instance_type = "t3.small"               # 사용할 인스턴스 유형으로 변경
  key_name      = "lab6"                    # 사용할 키 페어 이름으로 변경

  security_groups = "sg-03f416246cf746bf8"

  tags = {
    Name = "MinecraftServer"
  }
}
