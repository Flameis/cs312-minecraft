#!/bin/bash

echo "Initializing Terraform..."

cd terraform
terraform init
terraform fmt
terraform validate

echo "Infrastructure initialized. Ready to deploy."