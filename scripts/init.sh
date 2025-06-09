#!/bin/bash

set -e

echo "=== Initializing Minecraft Server Infrastructure ==="

# Check if AWS CLI is configured
if ! aws sts get-caller-identity > /dev/null 2>&1; then
    echo "Error: AWS CLI not configured. Please run 'aws configure' first."
    exit 1
fi

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "Error: Terraform not found. Please install Terraform v1.5+"
    exit 1
fi

# Navigate to terraform directory
cd terraform

echo "Initializing Terraform..."
terraform init

echo "Validating Terraform configuration..."
terraform validate

echo "Formatting Terraform files..."
terraform fmt

echo "=== Initialization Complete ==="
echo "Next steps:"
echo "  1. Run ./scripts/plan.sh to see what will be created"
echo "  2. Run ./scripts/apply.sh to create the infrastructure"
