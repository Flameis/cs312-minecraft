#!/bin/bash

echo "Rebooting Minecraft server instance..."

cd terraform
INSTANCE_IP=$(terraform output -raw instance_public_ip)
INSTANCE_ID=$(terraform output -raw instance_id)

echo "Rebooting instance $INSTANCE_ID at $INSTANCE_IP..."

# Reboot the EC2 instance
aws ec2 reboot-instances --instance-ids $INSTANCE_ID

echo "Instance reboot initiated. Waiting for instance to come back online..."

# Wait for instance to be running again
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

echo "Instance is running. Waiting for SSH to be available..."

# Use SSH key from environment variable or local file
if [ -n "$SSH_KEY" ]; then
    echo "$SSH_KEY" > ../minecraft-key
    chmod 600 ../minecraft-key
    SSH_KEY_FILE="../minecraft-key"
elif [ -f "../minecraft-key" ]; then
    SSH_KEY_FILE="../minecraft-key"
else
    echo "Error: No SSH key found. Set SSH_KEY environment variable or place key at minecraft-key"
    exit 1
fi

# Wait for SSH to be available (may take a few minutes after reboot)
until ssh -i "$SSH_KEY_FILE" -o ConnectTimeout=5 -o StrictHostKeyChecking=no ubuntu@$INSTANCE_IP exit 2>/dev/null; do
    echo "Waiting for SSH to be available..."
    sleep 10
done

echo "SSH is available. Checking Minecraft service status..."

# Check if Minecraft service is running
ssh -i "$SSH_KEY_FILE" -o StrictHostKeyChecking=no ubuntu@$INSTANCE_IP <<'EOF'
echo "Checking Minecraft service status..."
sudo systemctl status minecraft --no-pager

if sudo systemctl is-active minecraft | grep -q "active"; then
    echo "Minecraft service is running!"
else
    echo "Minecraft service is not running. Starting it..."
    sudo systemctl start minecraft
    sleep 10
    sudo systemctl status minecraft --no-pager
fi
EOF

echo "Instance reboot completed!"
echo "Connect to: $INSTANCE_IP:25565"
