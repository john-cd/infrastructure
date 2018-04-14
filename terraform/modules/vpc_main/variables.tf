variable "environment_name" {
  description = "Environment name (dev, staging, prod..)"
  type        = "string"
  default     = "dev"
}

variable "zones" {
  description = "Availability zones"
  type        = "list"
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "vpc_cidr" {
  description = "CIDR of the VPC e.g. 10.0.0.0/16"
  default     = "10.0.0.0/16"
}
