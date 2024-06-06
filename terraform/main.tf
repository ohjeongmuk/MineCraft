provider "aws" {
  region = "us-west-2"
}

data "aws_instance" "minecraft" {
  instance_id = "i-0ba311bacff7784d4"
}

data "aws_security_group" "existing_security_group" {
  id = "sg-03f416246cf746bf8"
}

output "instance_ip" {
  value = data.aws_instance.minecraft.public_ip
}
