variable "aws_region" {
  description = "AWS region e.g. us-west-2"
  type        = "string"
  default     = "us-west-2"
}

variable "credentials_file" {
  description = "Path to the credentials file containing the AWS access and secret keys, relative to the root module path"
  type        = "string"
  default     = "../../credentials/credentials"
}

variable "credentials_profile" {
  description = "Profile within the AWS credentials file to use"
  type        = "string"
}

variable "domain_name" {
  description = "Domain name of an existing DNS zone e.g. example.domain"
  type        = "string"
}

variable "subdomain" {
  description = "DNS subdomain to create e.g. api or www"
  type        = "string"
}

variable "elb_dns_name" {
  description = "SDNS name of the ELB"
  type        = "string"
}

variable "elb_zone_id" {
  description = "Canonical hosted zone ID of the ELB"
  type        = "string"
}
