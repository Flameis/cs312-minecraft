#!/bin/bash

echo "Testing server..."

cd terraform
INSTANCE_IP=$(terraform output -raw instance_public_ip)

echo "Testing $INSTANCE_IP..."

# SSH test
ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no ec2-user@$INSTANCE_IP exit && echo "SSH: OK" || echo "SSH: FAILED"

# Service test via SSH
ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no ec2-user@$INSTANCE_IP "sudo systemctl is-active minecraft" | grep -q "active" && echo "Minecraft service: Running" || echo "Minecraft service: NOT RUNNING"

# Port test
if command -v nmap &> /dev/null; then
    nmap -p 25565 $INSTANCE_IP | grep -q "open" && echo "Port 25565: Open" || echo "Port 25565: CLOSED"
else
    timeout 5 bash -c "</dev/tcp/$INSTANCE_IP/25565" && echo "Port 25565: Open" || echo "Port 25565: CLOSED"
fi

echo ""
echo "Connect to: $INSTANCE_IP:25565"
