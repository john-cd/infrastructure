variable "vpc_id" {
  description = "VPC ID"
  type        = "string"
}

variable "public_subnet_ids" {
  type = "list"
}

variable "private_subnet_ids" {
  type = "list"
}

variable "aws_key_name" {}

variable "aws_key_location" {}

variable "zones" {
  type = "list"
}
