#!/bin/bash

echo "Configuring Minecraft server..."

# Load .env
[ -f "../.env" ] && export $(grep -v '^#' ../.env | xargs)

export AWS_ACCESS_KEY_ID=$aws_access_key_id
export AWS_SECRET_ACCESS_KEY=$aws_secret_access_key
export AWS_SESSION_TOKEN=$aws_session_token
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-west-2}

cd ansible

INSTANCE_IP=$(jq -r '.instance_public_ip.value' terraform_outputs.json)
echo "Configuring server at $INSTANCE_IP..."

# Wait for SSH
echo "Waiting for SSH..."
until ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no ec2-user@$INSTANCE_IP exit 2>/dev/null; do
    sleep 10
done

ansible-playbook -i inventory/aws_ec2.yml playbooks/minecraft-setup.yml

echo "Server configured! Connect at: $INSTANCE_IP:25565"
