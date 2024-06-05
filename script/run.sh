#!/bin/bash

# Terraform을 사용하여 AWS 인프라를 프로비저닝합니다.
cd terraform
terraform init
terraform apply -auto-approve

# Ansible을 사용하여 Minecraft 서버를 설정합니다.
cd ../ansible
ansible-playbook playbook.yml

# 프로비저닝 및 설정이 완료되면 Minecraft 서버를 시작합니다.
cd ../script
./start_minecraft.sh
