#!/bin/bash

echo "Initializing Terraform..."

# Load .env if it exists
[ -f ".env" ] && export $(grep -v '^#' .env | xargs)

# Set AWS credentials from .env
export AWS_ACCESS_KEY_ID=$aws_access_key_id
export AWS_SECRET_ACCESS_KEY=$aws_secret_access_key
export AWS_SESSION_TOKEN=$aws_session_token
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-west-2}

cd terraform
terraform init
terraform fmt
terraform validate

echo "Ready to plan infrastructure."
