output "instance_private_ips" {
  description = "Private IP addresses of the EC2 instances"
  value       = module.ec2_instances[*].private_ip
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_public_subnets" {
  description = "List of IDs of the VPC's public subnets"
  value       = module.vpc.public_subnets
}

output "vpc_private_subnets" {
  description = "List of IDs of the VPC's private subnets"
  value       = module.vpc.private_subnets
}
