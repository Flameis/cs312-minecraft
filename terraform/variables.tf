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
  default     = "ami-0a605bc2ef5707a18" # Ubuntu Server 24.04 LTS (HVM),EBS in us-west-2
}

variable "key_name" {
  description = "Name of the AWS key pair to use for SSH access"
  type        = string
  default     = "minecraft-server-key"
}