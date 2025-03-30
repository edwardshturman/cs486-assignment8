# Contains Packer settings
packer {
  # Plugins required by the template to build the image
  required_plugins {
    amazon = {
      # Maintained by HashiCorp
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# Constants, cannot be updated at runtime
variable "ami_name" {
  type    = string
  default = "learn-packer-aws"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "aws_region" {
  type    = string
  default = "us-west-1"
}

# Configures a specific builder plugin
# Builder type and name, e.g. source "type" "name"
source "amazon-ebs" "ubuntu" {
  ami_name      = var.ami_name
  instance_type = var.instance_type
  region        = var.aws_region

  # The base AMI to use for the build
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

# What should be done with the container after it launches
build {
  name = "learn-packer"
  sources = [
    # Reference syntax: source.<type>.<name> as defined in the source block
    "source.amazon-ebs.ubuntu"
  ]
}
