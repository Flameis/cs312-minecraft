#!/bin/bash

echo "Destroying infrastructure..."

export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-west-2}

read -p "Destroy everything? (yes/no): " confirm
[ "$confirm" != "yes" ] && exit 0

cd terraform
terraform destroy -auto-approve

rm -f tfplan

echo "Everything destroyed."
