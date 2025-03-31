variable "ami" {
  description = "The AMI ID to use for the EC2 instances"
  type        = string
  default     = "ami-0fa75d35c5505a879" # Amazon Linux 2023 AMI 64-bit x86
}

variable "instance_prefix" {
  description = "A prefix for the Name tag for the EC2 instance cluster"
  type        = string
  default     = "cs486-assignment8-edwardshturman"
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 6
}

variable "vpc_name" {
  description = "Name of the VPC to use for the EC2 instance cluster"
  type        = string
  default     = "cs486-assignment8-edwardshturman-vpc"
}

variable "allow_ssh_ip" {
  description = "An IPv4 address from which SSH access is allowed"
  type        = string
  default     = ""
}

variable "public_key" {
  description = "Public key for SSH access to the bastion host"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDzPKTwRtGWT74BNpNSHslV5t7X4Ehma83w3Fc6d/4APvaHVOdMrvfFPO/bUxbzLLbyd3kpk4lnNnsQG+VZhIh9IUC0i13c1RHh+dXIhXwlxdfEHfPfCdqwCp0G1fmu3D5jac/5yUc3YwQletlwwEKZxiBdiHAd1yElXzDXSZMxV75Y4FBILZkvyjiPAGGcWJf2mpfIXjq/1gtCvXAUlLL0ZXsHfOd3SmApVDh73A1/SaL62W1ZOIHRH3PxqLyrCTq2awS9IbszHvewuLDyMa9CdJG7tOEbjwT855obZFx+1dNOiLmxQUBTAY+3GJ2U/AwIWiPnjwgLQihLsrXW282t"
}
