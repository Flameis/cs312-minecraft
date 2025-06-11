#!/bin/bash

echo "Restarting Minecraft server..."

cd terraform
INSTANCE_IP=$(terraform output -raw instance_public_ip)

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

echo "Restarting server at $INSTANCE_IP..."

# Restart the Minecraft service
ssh -i "$SSH_KEY_FILE" -o StrictHostKeyChecking=no ubuntu@$INSTANCE_IP <<'EOF'
echo "Stopping Minecraft server..."
sudo systemctl stop minecraft
sleep 5

echo "Starting Minecraft server..."
sudo systemctl start minecraft
sleep 10

echo "Checking status..."
sudo systemctl status minecraft --no-pager
EOF

echo "Minecraft server restarted!"
echo "Connect to: $INSTANCE_IP:25565"
