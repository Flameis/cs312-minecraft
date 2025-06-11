#!/bin/bash

echo "Destroying infrastructure..."

read -p "Destroy everything? (yes/no): " confirm
[ "$confirm" != "yes" ] && exit 0

cd terraform
terraform destroy -auto-approve

rm -f tfplan

echo "Everything destroyed."
