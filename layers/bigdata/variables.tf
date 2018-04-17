variable "api_remote_backend_region" {
  description = "AWS region for the remote backend S3 bucket for the API layer e.g. us-west-2"
  type        = "string"
  default     = "us-west-2"
}

variable "api_remote_backend_bucket" {
  description = "Name of the remote backend S3 bucket for the API layer"
  type        = "string"
  default     = "charliedelta-backend"
}

variable "environment_name" {
  description = "Environment name e.g. dev, staging, prod"
  type        = "string"
  default     = "dev"
}

variable "spark_slave_count" {
  description = "Number of Spark slaves"
  type        = "string"
  default     = "2"
}
