variable "aws_region" {
  description = "AWS region"
  type        = "string"
  default = "us-west-2"
}

variable "environment_name" {
  description = "Environment name e.g. dev, staging, prod..."
  type        = "string"
  default = "dev"
}
