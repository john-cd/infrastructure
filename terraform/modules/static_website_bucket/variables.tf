variable "region"        { 
	description = "AWS region e.g. us-west-2"
	type = "string"
}

variable "environment_name" { 
	description = "Name of the environment e.g. spark-dev, spark-staging..." 
	type = "string"
}

variable "application_name" {
	description = "Unique name of the application. The S3 bucket storing the static web site documents will be named {application}-{environment}-web"
	type = "string"
}

variable "log_bucket_id" {
  description = "ID of the buket used to store access logs (optional)"
  type        = "string"
  default = ""
}