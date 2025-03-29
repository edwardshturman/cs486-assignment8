# Contains Packer settings
packer {
  # Plugins required by the template to build the image
  required_plugins {
    docker = {
      # Maintained by HashiCorp
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

# Constants, cannot be updated at runtime
variable "docker_image" {
  type    = string
  default = "ubuntu:jammy"
}

# Configures a specific builder plugin
# Builder type and name, e.g. source "type" "name"
source "docker" "ubuntu" {
  image  = var.docker_image
  commit = true
}
source "docker" "ubuntu-focal" {
  image  = "ubuntu:focal"
  commit = true
}

# What should be done with the container after it launches
build {
  name = "learn-packer"
  sources = [
    # Reference syntax: source.<type>.<name> as defined in the source block
    "source.docker.ubuntu",
    "source.docker.ubuntu-focal"
  ]

  # Provisioners automate modifications to the image
  provisioner "shell" {
    environment_vars = [
      "FOO=hello world"
    ]
    inline = [
      "echo Adding file to Docker Container",
      "echo \"FOO is $FOO\" > example.txt"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo Running $(cat /etc/os-release | grep VERSION= | sed 's/\"//g' | sed 's/VERSION=//g') Docker image"
    ]
  }
}
