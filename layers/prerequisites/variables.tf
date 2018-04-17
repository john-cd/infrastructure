variable "region" {
  description = "AWS region e.g. us-west-2"
  type        = "string"
  default     = "us-west-2"
}

variable "application_name" {
  description = "Unique name of the application. The S3 bucket will be named {application}-backend"
  type        = "string"
  default     = "charliedelta"
}
