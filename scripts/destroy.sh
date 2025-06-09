#!/bin/bash

set -e

echo "=== Destroying Minecraft Server Infrastructure ==="

# Confirm destruction
read -p "Are you sure you want to destroy all infrastructure? This cannot be undone. (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Destruction cancelled."
    exit 0
fi

# Navigate to terraform directory
cd terraform

# Check if Terraform is initialized
if [ ! -d ".terraform" ]; then
    echo "Error: Terraform not initialized. Nothing to destroy."
    exit 1
fi

echo "Destroying infrastructure..."
terraform destroy -auto-approve

# Clean up generated files
echo "Cleaning up generated files..."
rm -f tfplan
rm -f ../ansible/terraform_outputs.json

echo "=== Destruction Complete ==="
echo "All AWS resources have been destroyed."
echo "Local files have been cleaned up."
