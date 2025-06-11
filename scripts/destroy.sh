#!/bin/bash

echo "Destroying infrastructure..."

aws ec2 terminate-instances --instance-ids $(terraform output -raw instance_id)
aws ec2 wait instance-terminated --instance-ids $(terraform output -raw instance_id)
aws ec2 delete-security-group --group-id $(terraform output -raw security_group_id) 2>/dev/null || true
aws ec2 delete-key-pair --key-name minecraft-server-key 2>/dev/null || true
echo "Waiting for resources to be cleaned up..."
sleep 40  # Wait for resources to be cleaned up

cd terraform
terraform destroy -auto-approve
rm -f tfplan

echo "Everything destroyed."
