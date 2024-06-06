provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "minecraft_start" {
  count         = 1
  instance_id   = "i-0ba311bacff7784d4" // 시작할 인스턴스의 ID로 대체합니다.
  
  lifecycle {
    create_before_destroy = true
  }

  provisioner "local-exec" {
    command = "aws ec2 start-instances --instance-ids ${self.instance_id}"
  }
}
