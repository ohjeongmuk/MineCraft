# MineCraft Server Provisioning

This repository contains scripts and configurations for provisioning a MineCraft server using Terraform and Ansible. This project automates the setup and deployment of a MineCraft server on AWS EC2 instances. It uses Terraform for infrastructure provisioning and Ansible for server configuration.

## Requirements

- Terraform was used to create AWS EC2 instances.
- Ansible was used to move the script file from the GitHub repository to EC2.
- The same script for installing the Minecraft server in Project 1 was used in Project 2.
- GitHub actions were linked for CI/CD automation.
- A GitHub secret was used to use Credential. aws_access_key_id, aws_secret_access_key, aws_session_token are saved

## Contents

- `terraform/`: Contains Terraform configuration files for provisioning AWS resources.
- `ansible/`: Contains Ansible playbooks and scripts for configuring the MineCraft server.
- `scripts/`: Contains additional scripts used in server configuration.
- `README.md`: Provides an overview of the project and instructions for usage.
- `.github/workflows`: CI/CD Automation GitHub Actions

## Github Action Setup
0. SetUP Security Group and New Key Pair

- Delete Old Security Group
```
    - name: Delete Existing Security Group
      run: |
        aws ec2 delete-security-group --group-name MineCraft
```
- Delete Old Key Pair
```
    - name: Check and delete existing key pair
      run: |
        KEY_NAME="minecraft-key"
        if aws ec2 describe-key-pairs --key-name $KEY_NAME > /dev/null 2>&1; then
          echo "Key pair $KEY_NAME exists. Deleting..."
          aws ec2 delete-key-pair --key-name $KEY_NAME
        else
          echo "Key pair $KEY_NAME does not exist. Proceeding..."
        fi

```


1. Intitialize Terraform and use lab6 public_key in AWS to create new instance. Save instance public IP address into instance_public_ip.txt on ../terraform/
```
    - name: Initialize Terraform
      run: |
        cd terraform
        terraform init
        terraform apply -auto-approve
        terraform output -raw private_key > ../terraform/minecraft_key.pem
        terraform output -json | jq -r '.instance_ip.value' > ../terraform/instance_public_ip.txt
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        AWS_SESSION_TOKEN: ${{ secrets.AWS_SESSION_TOKEN }}
        AWS_REGION: us-west-2  # 원하는 리전을 여기에 명시합니다.
        SSH_PRIVATE_KEY: ${{ secrets.SSH_PRIVATE_KEY }}
```

2. Set Up Python and Install Ansible
```
    - name: Set up Python
      uses: actions/setup-python@v2
      with:
        python-version: '3.x'

    - name: Install Ansible
      run: pip install ansible
```
3. Set Up SSH key and save it into ~/.ssh/id_rsa with 600 authorization
```
    - name: Setup SSH key
      run: |
        mkdir -p ~/.ssh
        echo "${{ secrets.SSH_PRIVATE_KEY }}" > ~/.ssh/id_rsa
        chmod 600 ~/.ssh/id_rsa
```

4. To allow Ansible to access the instance, declare public IP and Ansible Host
```
    - name: Create Ansible inventory
      run: |
        INSTANCE_IP=$(cat terraform/instance_public_ip.txt)
        echo "[minecraft]" > ansible_hosts
        echo "$INSTANCE_IP ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> ansible_hosts

    - name: Display Ansible inventory
      run: cat ansible_hosts
```

5. Implement Ansible playbook
```
    - name: Run Ansible playbook
      run: ansible-playbook -i ansible_hosts ansible/playbook.yml
```
   
6. To check if the IP is open or not, set up nmap
```
    - name: Check Minecraft server with nmap
      run: |
        sudo apt update && sudo apt install -y nmap
        INSTANCE_IP=$(cat terraform/instance_public_ip.txt)
        sleep 15
        nmap -sV -Pn -p T:25565 $INSTANCE_IP
```

## Configuration

- Modify `secrets.AWS_ACCESS_KEY_ID` to access AWS console.
- Modify `secrets.AWS_SECRET_ACCESS_KEY` to access AWS console.
- Modify `secrets.AWS_SESSION_TOKEN` to access AWS console.
- Modify `ansible/playbook.yml` to customize server setup tasks.
- Additional configurations can be done in respective Terraform and Ansible files such as VPC, Security Group, Subnet.

## Contributing

Contributions are welcome! If you have any suggestions, improvements, or bug fixes, feel free to open an issue or create a pull request. Thie project will be updated with Dockerfile in the future.

## License

This project is licensed under ohjeo@oregonstate.edu
