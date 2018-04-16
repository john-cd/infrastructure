variable "vpc_id" {
  description = "VPC ID"
  type        = "string"
}

variable "zones" {
  description = "List of availability zones in the VPC"
  type = "list"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs in the VPC"
  type = "list"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs in the VPC"
  type = "list"
}

variable "instance_name" {
  description = "Instance name"
  type        = "string"
}

variable "aws_key_name" {
  description = "The name of the AWS key pair to provision the instances with"
  type        = "string"
}

variable "aws_key_location" {
  description = "The contents of private key file for the bastion instance (required for ssh_bastion_host)"
    type        = "string"
}

