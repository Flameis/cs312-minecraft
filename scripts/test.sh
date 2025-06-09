#!/bin/bash

set -e

echo "=== Testing Minecraft Server Deployment ==="

# Navigate to ansible directory
cd ansible

# Check if infrastructure exists
if [ ! -f "terraform_outputs.json" ]; then
    echo "Error: No Terraform outputs found. Please run ./scripts/apply.sh first."
    exit 1
fi

# Get instance IP
INSTANCE_IP=$(jq -r '.instance_public_ip.value' terraform_outputs.json)

if [ "$INSTANCE_IP" = "null" ] || [ -z "$INSTANCE_IP" ]; then
    echo "Error: Could not get instance IP from Terraform outputs."
    exit 1
fi

echo "Testing server at IP: $INSTANCE_IP"

# Test SSH connectivity
echo "1. Testing SSH connectivity..."
if ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no ec2-user@$INSTANCE_IP exit 2>/dev/null; then
    echo "   ✓ SSH connection successful"
else
    echo "   ✗ SSH connection failed"
    exit 1
fi

# Test Ansible connectivity
echo "2. Testing Ansible connectivity..."
if ansible all -i inventory/aws_ec2.yml -m ping > /dev/null 2>&1; then
    echo "   ✓ Ansible connectivity successful"
else
    echo "   ✗ Ansible connectivity failed"
    exit 1
fi

# Check Minecraft service status
echo "3. Checking Minecraft service status..."
SERVICE_STATUS=$(ansible all -i inventory/aws_ec2.yml -m systemd -a "name=minecraft" --one-line | grep -o "active=\w*" | cut -d= -f2)
if [ "$SERVICE_STATUS" = "active" ]; then
    echo "   ✓ Minecraft service is running"
else
    echo "   ✗ Minecraft service is not running (status: $SERVICE_STATUS)"
fi

# Test Minecraft port connectivity
echo "4. Testing Minecraft port connectivity..."
if command -v nmap &> /dev/null; then
    echo "   Using nmap to test port 25565..."
    if nmap -sV -Pn -p T:25565 $INSTANCE_IP | grep -q "25565/tcp open"; then
        echo "   ✓ Minecraft port 25565 is accessible"
    else
        echo "   ✗ Minecraft port 25565 is not accessible"
    fi
else
    echo "   nmap not found, using telnet..."
    if timeout 5 bash -c "</dev/tcp/$INSTANCE_IP/25565" 2>/dev/null; then
        echo "   ✓ Minecraft port 25565 is accessible"
    else
        echo "   ✗ Minecraft port 25565 is not accessible"
    fi
fi

echo ""
echo "=== Test Results Summary ==="
echo "Server IP: $INSTANCE_IP"
echo "Minecraft Port: 25565"
echo "Connection String: $INSTANCE_IP:25565"
echo ""
echo "To connect from Minecraft client:"
echo "1. Open Minecraft Java Edition"
echo "2. Go to Multiplayer > Add Server"
echo "3. Server Address: $INSTANCE_IP:25565"
echo ""
echo "To view server logs:"
echo "  ansible all -i inventory/aws_ec2.yml -m shell -a 'journalctl -u minecraft -n 50'"
