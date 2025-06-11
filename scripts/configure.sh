#!/bin/bash

echo "Configuring Minecraft server..."

cd terraform

INSTANCE_IP=$(terraform output -raw instance_public_ip)
echo "Configuring server at $INSTANCE_IP..."

# Wait for SSH
echo "Waiting for SSH..."
until ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no ec2-user@$INSTANCE_IP exit 2>/dev/null; do
    echo "Waiting for SSH to be available..."
    sleep 10
done

echo "Installing Java and setting up Minecraft server..."

# Install Java and dependencies
ssh -o StrictHostKeyChecking=no ec2-user@$INSTANCE_IP << 'EOF'
sudo yum update -y
sudo yum install -y java-17-amazon-corretto-headless wget

# Create minecraft directory
mkdir -p ~/minecraft
cd ~/minecraft

# Download latest Minecraft server
echo "Downloading Minecraft server..."
wget -O server.jar https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar

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
User=ec2-user
WorkingDirectory=/home/ec2-user/minecraft
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

echo "Minecraft server configured and started!"
EOF

echo "Server configured! Connect at: $INSTANCE_IP:25565"
