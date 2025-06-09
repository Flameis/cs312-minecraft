#!/bin/bash

set -e

echo "=== Configuring Minecraft Server ==="

# Check if Ansible is installed
if ! command -v ansible &> /dev/null; then
    echo "Error: Ansible not found. Please install Ansible v2.9+"
    exit 1
fi

# Navigate to ansible directory
cd ansible

# Check if infrastructure exists
if [ ! -f "terraform_outputs.json" ]; then
    echo "Error: No Terraform outputs found. Please run ./scripts/apply.sh first."
    exit 1
fi

# Wait for instance to be ready
echo "Waiting for EC2 instance to be ready..."
INSTANCE_IP=$(jq -r '.instance_public_ip.value' terraform_outputs.json)

if [ "$INSTANCE_IP" = "null" ] || [ -z "$INSTANCE_IP" ]; then
    echo "Error: Could not get instance IP from Terraform outputs."
    exit 1
fi

echo "Instance IP: $INSTANCE_IP"

# Wait for SSH to be available
echo "Waiting for SSH connection..."
for i in {1..30}; do
    if ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no ec2-user@$INSTANCE_IP exit 2>/dev/null; then
        echo "SSH connection established!"
        break
    fi
    echo "Attempt $i/30 - SSH not ready yet, waiting 10 seconds..."
    sleep 10
done

# Check Ansible connectivity
echo "Testing Ansible connectivity..."
ansible all -i inventory/aws_ec2.yml -m ping

# Run the Minecraft setup playbook
echo "Running Minecraft server configuration..."
ansible-playbook -i inventory/aws_ec2.yml playbooks/minecraft-setup.yml

echo "=== Configuration Complete ==="
echo "Next steps:"
echo "  1. Run ./scripts/test.sh to validate the deployment"
echo "  2. Connect to the server at: $INSTANCE_IP:25565"
