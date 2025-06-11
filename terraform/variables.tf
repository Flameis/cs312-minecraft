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
  default     = "ami-08d70e59c07c61a3a" # Example AMI ID, replace with a valid one for your region
}