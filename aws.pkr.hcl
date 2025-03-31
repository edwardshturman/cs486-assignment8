packer {
  required_plugins {
    amazon = {
      version = "1.3.6"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_prefix" {
  type    = string
  default = "cs486-assignment8-edwardshturman"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "aws_region" {
  type    = string
  default = "us-west-1"
}

locals {
  timestamp = regex_replace(timestamp(), "[-TZ:]", "")
}

source "amazon-ebs" "amazon-linux" {
  region        = var.aws_region
  source_ami    = "ami-0fa75d35c5505a879" # Amazon Linux 2023 AMI 64-bit x86
  instance_type = var.instance_type
  ssh_username  = "ec2-user"
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
}

build {
  name = "cs486-assignment8-edwardshturman"
  sources = [
    "source.amazon-ebs.amazon-linux"
  ]

  provisioner "shell" {
    inline = [
      "echo \"Upgrading packages\"",
      "sudo yum update -y",
      "echo \"Upgraded packages\""
    ]
  }

  provisioner "shell" {
    inline = [
      "echo \"Installing Docker\"",
      "sudo yum install -y docker",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "sudo docker run hello-world",
      "echo \"Docker installed\""
    ]
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }

  post-processor "shell-local" {
    inline = [<<EOF
echo "ami = \"$(cat manifest.json | jq -r .builds[0].artifact_id |  cut -d':' -f2)\"" >> terraform.tfvars
echo "Added AMI ID to terraform.tfvars"
EOF
    ]
  }
}
