#!/bin/bash

set -e

echo "=== Applying Minecraft Server Infrastructure ==="

# Navigate to terraform directory
cd terraform

# Check if plan file exists
if [ ! -f "tfplan" ]; then
    echo "Error: No execution plan found. Please run ./scripts/plan.sh first."
    exit 1
fi

echo "Applying Terraform plan..."
terraform apply tfplan

echo "Getting infrastructure outputs..."
terraform output

# Generate Ansible inventory
echo "Generating Ansible inventory..."
terraform output -json > ../ansible/terraform_outputs.json

echo "=== Infrastructure Deployment Complete ==="
echo "Next steps:"
echo "  1. Wait 2-3 minutes for instance to fully boot"
echo "  2. Run ./scripts/configure.sh to configure the Minecraft server"
