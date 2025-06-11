#!/bin/bash

echo "Destroying infrastructure..."

export AWS_DEFAULT_REGION=us-west-2

cd terraform
terraform destroy -auto-approve
rm -f tfplan

echo "Everything destroyed."
