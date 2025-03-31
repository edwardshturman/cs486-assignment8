provider "aws" {
  region = "us-west-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name               = var.vpc_name
  cidr               = "10.0.0.0/16"
  azs                = ["us-west-1a", "us-west-1b", "us-west-1c"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true
}

resource "aws_key_pair" "bastion-key" {
  key_name   = "bastion-key"
  public_key = var.public_key
}

module "bastion" {
  source  = "umotif-public/bastion/aws"
  version = "2.0.0"

  region                 = "us-west-1"
  ami_id                 = "ami-0fa75d35c5505a879" # Amazon Linux 2023 AMI 64-bit x86
  bastion_instance_types = ["t2.micro"]
  name_prefix            = var.instance_prefix
  vpc_id                 = module.vpc.vpc_id
  public_subnets         = module.vpc.public_subnets
  private_subnets        = module.vpc.private_subnets
  ingress_cidr_blocks    = ["${var.allow_ssh_ip}/32"]
  ssh_key_name           = "bastion-key"
}

resource "aws_security_group" "ec2_sg" {
  name   = "ec2-instance-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    description     = "Allow SSH from bastion host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [module.bastion.security_group_id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.8.0"

  count                  = var.instance_count
  name                   = "${var.instance_prefix}-${count.index + 1}"
  ami                    = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id              = module.vpc.private_subnets[0]
  key_name               = "bastion-key"
}
