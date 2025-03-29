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

# Configures a specific builder plugin
# Builder type and name, e.g. source "type" "name"
source "docker" "ubuntu" {
  image  = "ubuntu:jammy"
  commit = true
}

# What should be done with the container after it launches
build {
  name = "learn-packer"
  sources = [
    # Reference syntax: source.<type>.<name> as defined in the source block
    "source.docker.ubuntu"
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
      "echo Provisioned image"
    ]
  }
}
