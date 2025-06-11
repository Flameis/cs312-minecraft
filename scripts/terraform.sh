#!/bin/bash

echo "Creating infrastructure..."

cd terraform
terraform init
terraform fmt
terraform validate
terraform apply