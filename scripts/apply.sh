#!/bin/bash

echo "Creating infrastructure..."

# Load .env
[ -f "../.env" ] && export $(grep -v '^#' ../.env | xargs)

export AWS_ACCESS_KEY_ID=$aws_access_key_id
export AWS_SECRET_ACCESS_KEY=$aws_secret_access_key
export AWS_SESSION_TOKEN=$aws_session_token
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-west-2}

cd terraform
terraform apply tfplan
terraform output -json > ../ansible/terraform_outputs.json

echo "Infrastructure created. Wait a few minutes, then run configure.sh"
