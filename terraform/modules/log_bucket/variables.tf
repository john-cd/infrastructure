variable "region" {
  description = "AWS region e.g. us-west-2 (required)"
  type        = "string"
}

variable "application_name" {
  description = "Unique name of the application. The S3 bucket that will collect logs will be named {application}-{environment}-logs (required)"
  type        = "string"
}

variable "environment_name" {
  description = "Name of the environment e.g. dev, staging, prod (required)"
  type        = "string"
}
