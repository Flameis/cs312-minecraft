#!/bin/bash

echo "Installing dependencies..."

sudo apt-get update

# Install jq if not installed
if ! command -v jq &> /dev/null; then
    echo "jq not found, installing..."
    sudo apt-get install -y jq
else
    echo "jq is already installed."
fi

# Install openssh-client if not installed
if ! command -v ssh &> /dev/null; then
    echo "openssh-client not found, installing..."
    sudo apt-get install -y openssh-client
else
    echo "openssh-client is already installed."
fi

# Install nmap if not installed
if ! command -v nmap &> /dev/null; then
    echo "nmap not found, installing..."
    sudo apt-get install -y nmap
else
    echo "nmap is already installed."
fi

# Install unzip if not installed
if ! command -v unzip &> /dev/null; then
    echo "unzip not found, installing..."
    sudo apt-get install -y unzip
else
    echo "unzip is already installed."
fi

# Install aws-cli if not installed
if ! command -v aws &> /dev/null; then
    echo "aws-cli not found, installing..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
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