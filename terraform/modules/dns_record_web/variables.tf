variable "region" {
  description = "AWS region e.g. us-west-2"
  type        = "string"
  default     = "us-west-2"
}

variable "credentials_file" {
  description = "Path to the credentials file containing the AWS access and secret keys, e.g. ${path.root}/../../credentials/credentials"
  type        = "string"
}

variable "credentials_profile" {
  description = "Profile within the AWS credentials file to use e.g. default"
  type        = "string"
}

variable "zone_domain_name" {
  description = "Domain name of an existing DNS zone e.g. example.domain"
  type        = "string"
}

variable "subdomain" {
  description = "DNS subdomain to create e.g. api or www"
  type        = "string"
}

variable "hosted_zone_id" {
  description = "Hosted zone ID of an existing static website S3 bucket."
  type        = "string"
}

variable "website_domain" {
  description = ""
  type        = "string"
}
