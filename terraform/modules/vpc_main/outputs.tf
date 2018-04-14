# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.vpc_main.vpc_id}"
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.vpc_main.private_subnets}"]
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = ["${module.vpc_main.public_subnets}"]
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = ["${module.vpc_main.database_subnets}"]
}

output "elasticache_subnets" {
  description = "List of IDs of elasticache subnets"
  value       = ["${module.vpc_main.elasticache_subnets}"]
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${module.vpc_main.nat_public_ips}"]
}
