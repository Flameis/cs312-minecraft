#!/bin/bash

echo "Creating infrastructure..."

# Configure AWS CLI if not already configured
if ! aws sts get-caller-identity &>/dev/null; then
    echo "AWS CLI not configured. Please configure it using 'aws configure'."
    exit 1
else
    echo "AWS CLI is configured."
fi

export AWS_DEFAULT_REGION=us-west-2
export TF_VAR_instance_type=t3.small
export TF_VAR_minecraft_port=25565

# Set the SSH key from file if it exists
SSH_KEY_FILE="../minecraft-key"
if [ -f "$SSH_KEY_FILE" ] && [ -z "$SSH_KEY" ]; then
    echo "Using existing SSH key file: $SSH_KEY_FILE"
    SSH_KEY=$(cat "$SSH_KEY_FILE")
else if [ -z "$SSH_KEY" ]; then
    echo "No SSH key file found at $SSH_KEY_FILE, creating a new key pair."
    ssh-keygen -t rsa -b 2048 -f minecraft-key -N "" || { echo "Failed to generate SSH key"; exit 1; }
    echo "SSH key pair generated: minecraft-key and minecraft-key.pub"
    # Set the SSH key to the environment variable
    SSH_KEY=$(cat minecraft-key)
    export SSH_KEY
    echo "SSH key set in environment variable."
else
    echo "Using provided SSH key from environment variable."
    echo "$SSH_KEY" > minecraft-key
    chmod 600 minecraft-key
fi

# Create or update the key pair in AWS
aws ec2 delete-key-pair --key-name minecraft-server-key 2>/dev/null || true
aws ec2 import-key-pair --key-name minecraft-server-key --public-key-material fileb://minecraft-key.pub

cd terraform
terraform init
terraform fmt
terraform validate
terraform apply -auto-approve

sleep 10  # Wait for resources to be ready

echo "Infrastructure created."
echo "Configuring Minecraft server..."

INSTANCE_IP=$(terraform output -raw instance_public_ip)

# Use SSH key from environment variable or local file
if [ -n "$SSH_KEY" ]; then
    echo "Using SSH key from environment variable..."
    echo "$SSH_KEY" > ../minecraft-key
    chmod 600 ../minecraft-key
    SSH_KEY_FILE="../minecraft-key"
elif [ -f "../minecraft-key" ]; then
    echo "Using existing SSH key file..."
    SSH_KEY_FILE="../minecraft-key"
else
    echo "Error: No SSH key found. Set SSH_KEY environment variable or place key at minecraft-key"
    exit 1
fi

echo "Configuring server at $INSTANCE_IP..."

# Wait for SSH
until ssh -i "$SSH_KEY_FILE" -o ConnectTimeout=5 -o StrictHostKeyChecking=no ubuntu@$INSTANCE_IP exit 2>/dev/null; do
    echo "Waiting for SSH to be available..."
    sleep 10
done

echo "Installing Java and setting up Minecraft server..."

# Install Java and dependencies
ssh -i "$SSH_KEY_FILE" -o StrictHostKeyChecking=no ubuntu@$INSTANCE_IP <<'EOF'
sudo apt update && sudo apt upgrade -y
sudo apt install default-jre default-jdk -y

# Create minecraft directory
mkdir -p ~/minecraft
cd ~/minecraft

# Download latest Minecraft server
echo "Downloading Minecraft server..."
wget -O server.jar $(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r '.latest.release as $latest | .versions[] | select(.id == $latest) | .url' | xargs curl -s | jq -r '.downloads.server.url')

# Accept EULA
echo 'eula=true' > eula.txt

# Create server properties with basic settings
cat > server.properties << 'PROPS'
server-port=25565
gamemode=survival
difficulty=easy
spawn-protection=16
max-players=20
online-mode=true
PROPS

# Create systemd service
sudo tee /etc/systemd/system/minecraft.service > /dev/null << 'SERVICE'
[Unit]
Description=Minecraft Server
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/minecraft
ExecStart=/usr/bin/java -Xmx1G -Xms1G -jar server.jar nogui
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICE

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable minecraft
sudo systemctl start minecraft
sudo systemctl status minecraft

echo "Minecraft server configured and started!"
EOF

echo "Server configured! Connect at: $INSTANCE_IP:25565"