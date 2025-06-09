#!/bin/bash

echo "Destroying infrastructure..."

# Load .env
[ -f "../.env" ] && export $(grep -v '^#' ../.env | xargs)

export AWS_ACCESS_KEY_ID=$aws_access_key_id
export AWS_SECRET_ACCESS_KEY=$aws_secret_access_key
export AWS_SESSION_TOKEN=$aws_session_token
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-west-2}

read -p "Destroy everything? (yes/no): " confirm
[ "$confirm" != "yes" ] && exit 0

cd terraform
terraform destroy -auto-approve

rm -f tfplan ../ansible/terraform_outputs.json

echo "Everything destroyed."
