#!/bin/bash

echo "Installing dependencies..."

sudo apt-get update
sudo apt-get install -y jq nmap openssh-client

# Install aws-cli if not installed

if ! command -v aws &> /dev/null; then
    echo "aws-cli not found, installing..."
    sudo apt-get install -y awscli
else
    echo "aws-cli is already installed."
fi

# Install terraform if not installed
if ! command -v terraform &> /dev/null; then
    echo "terraform not found, installing..."
    wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install terraform
    echo "terraform installed successfully."
else
    echo "terraform is already installed."
fi