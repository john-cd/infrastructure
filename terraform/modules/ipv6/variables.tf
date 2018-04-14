variable "vpc_id" {
  description = "VPC ID"
  type        = "string"
}

variable "private_route_table_ids" {
  description = "List of route table ids for private subnets"
  type        = "list"
}
