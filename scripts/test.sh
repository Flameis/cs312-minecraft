#!/bin/bash

echo "Testing server..."

cd terraform
INSTANCE_IP=$(terraform output -raw instance_public_ip)

# Use SSH key from environment variable or local file
if [ -n "$SSH_KEY" ]; then
    echo "$SSH_KEY" > ../minecraft-key.pem
    chmod 600 ../minecraft-key.pem
    SSH_KEY_FILE="../minecraft-key.pem"
elif [ -f "../minecraft-key.pem" ]; then
    SSH_KEY_FILE="../minecraft-key.pem"
else
    echo "Error: No SSH key found. Set SSH_KEY environment variable or place key at minecraft-key.pem"
    exit 1
fi

echo "Testing $INSTANCE_IP..."

# SSH test
ssh -i "$SSH_KEY_FILE" -o ConnectTimeout=10 -o StrictHostKeyChecking=no ubuntu@$INSTANCE_IP exit && echo "SSH: OK" || echo "SSH: FAILED"

# Service test via SSH
ssh -i "$SSH_KEY_FILE" -o ConnectTimeout=10 -o StrictHostKeyChecking=no ubuntu@$INSTANCE_IP "sudo systemctl is-active minecraft" | grep -q "active" && echo "Minecraft service: Running" || echo "Minecraft service: NOT RUNNING"

nmap -sV -Pn -p T:25565 $INSTANCE_IP

echo "Connect to: $INSTANCE_IP:25565 in the Minecraft client."
echo "Test completed."
