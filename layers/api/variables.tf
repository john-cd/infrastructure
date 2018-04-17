variable "region" {
  description = "AWS region e.g. us-west-2"
  type        = "string"
  default     = "us-west-2"
}

variable "zones" {
  description = "Availability zones e.g. [\"us-west-2a\", \"us-west-2b\", \"us-west-2c\"]"
  type        = "list"
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "application_name" {
  description = "Unique name of the application"
  type        = "string"
  default     = "charliedelta"
}

variable "environment_name" {
  description = "Environment name e.g. dev, staging, prod"
  type        = "string"
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR of the VPC e.g. 10.0.0.0/16"
  type        = "string"
  default     = "10.0.0.0/16"
}

variable "public_key_path" {
  description = "File path to the public key file, relative to the root module. See docs/ for instructions on how to generate the key file"
  type        = "string"
  default     = "../../credentials/main-ec2-key.pub"
}

variable "admin_email" {
  description = "Email address of the Kubernetes administrator"
  type        = "string"
  default     = "sjncd2000@gmail.com"
}

variable "admin_password" {
  description = "Password of the Kubernetes administrator"
  type        = "string"
}
