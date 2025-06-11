variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "MinecraftServer"
}

variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
  default     = "t3.small"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-07b8a117da8f2c473" # Ubuntu Server 20.04 LTS in us-west-2
}

variable "key_name" {
  description = "Name of the AWS key pair to use for SSH access"
  type        = string
  default     = "minecraft-server-key"
}