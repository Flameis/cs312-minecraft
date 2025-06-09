#!/bin/bash

set -e

echo "=== Planning Minecraft Server Infrastructure ==="

# Navigate to terraform directory
cd terraform

# Check if Terraform is initialized
if [ ! -d ".terraform" ]; then
    echo "Error: Terraform not initialized. Please run ./scripts/init.sh first."
    exit 1
fi

echo "Creating Terraform execution plan..."
terraform plan -out=tfplan

echo "=== Plan Complete ==="
echo "Review the plan above. If it looks correct, run ./scripts/apply.sh to apply the changes."
