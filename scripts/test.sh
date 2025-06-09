#!/bin/bash

echo "Testing server..."

cd ansible
INSTANCE_IP=$(jq -r '.instance_public_ip.value' terraform_outputs.json)

echo "Testing $INSTANCE_IP..."

# SSH test
ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no ec2-user@$INSTANCE_IP exit && echo "SSH: OK"

# Ansible test
ansible all -i inventory/aws_ec2.yml -m ping > /dev/null && echo "Ansible: OK"

# Service test
ansible all -i inventory/aws_ec2.yml -m systemd -a "name=minecraft" --one-line | grep -q "active" && echo "Minecraft service: Running"

# Port test
if command -v nmap &> /dev/null; then
    nmap -p 25565 $INSTANCE_IP | grep -q "open" && echo "Port 25565: Open"
else
    timeout 5 bash -c "</dev/tcp/$INSTANCE_IP/25565" && echo "Port 25565: Open"
fi

echo ""
echo "Connect to: $INSTANCE_IP:25565"
