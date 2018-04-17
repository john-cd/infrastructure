variable "region" {
  description = "AWS region e.g. us-west-2"
  type        = "string"
}

variable "application_name" {
  description = "Unique name of the application"
  type        = "string"
}

variable "environment_name" {
  description = "Environment name e.g. dev, staging, prod"
  type        = "string"
}

variable "base_domain_name" {
  description = "base DNS domain of the cluster. It must NOT contain a trailing period. Some DNS providers will automatically add this if necessary."
  type        = "string"
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID"
  type        = "string"
}

variable "master_count" {
  description = "Number of master nodes"
  type        = "string"
}

variable "master_instance_type" {
  description = "Instance type for the master nodes e.g. t2.medium"
  type        = "string"
}

variable "master_subnet_ids" {
  description = "List of subnet IDs within an existing VPC to deploy master nodes into. Required to use an existing VPC and the list must match the AZ count."
  type        = "list"
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = "string"
}

variable "worker_instance_type" {
  description = "Instance type for the worker nodes e.g. t2.medium"
  type        = "string"
}

variable "worker_subnet_ids" {
  description = "List of subnet IDs within an existing VPC to deploy worker nodes into. Required to use an existing VPC and the list must match the AZ count."
  type        = "list"
}

/*
variable "etcd_instance_type" {
  description = "Instance type for the etcd nodes e.g. t2.medium"
  type        = "string"
}
*/

variable "ssh_key_name" {
  description = "Name of an SSH key located within the AWS region. Example: coreos-user."
  type        = "string"
}

variable "admin_email" {
  description = "Email address of the Kubernetes administrator"
  type        = "string"
}

variable "admin_password" {
  description = "Password of the Kubernetes administrator"
  type        = "string"
}





