# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.network.vpc_id}"
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.network.private_subnets}"]
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = ["${module.network.public_subnets}"]
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = ["${module.network.database_subnets}"]
}

output "elasticache_subnets" {
  description = "List of IDs of elasticache subnets"
  value       = ["${module.network.elasticache_subnets}"]
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${module.network.nat_public_ips}"]
}
