provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0fa75d35c5505a879" # Amazon Linux 2023 AMI 64-bit x86
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}
