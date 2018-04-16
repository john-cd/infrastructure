variable "environment_name" {
  description = "Environment name (e.g. mgmt, dev, staging, prod..)"
  type        = "string"
}

variable "zones" {
  description = "Availability zones e.g. ["us-west-2a", "us-west-2b", "us-west-2c"]"
  type        = "list"
}

variable "vpc_cidr" {
  description = "CIDR of the VPC e.g. 10.0.0.0/16"
  type        = "string"
}
