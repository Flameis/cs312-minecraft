terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
}

# Security group for Minecraft server
resource "aws_security_group" "minecraft_sg" {
  name_prefix = "minecraft-server-"
  description = "Security group for Minecraft server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "minecraft-security-group"
  }
}

# Key pair for SSH access
resource "aws_key_pair" "minecraft_key" {
  key_name   = "minecraft-server-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name              = aws_key_pair.minecraft_key.key_name
  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]

  tags = {
    Name = var.instance_name
  }
}
