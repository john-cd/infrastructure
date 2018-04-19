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

/* TODO
variable "base_domain_name" {
  description = "base DNS domain of the cluster. It must NOT contain a trailing period. Some DNS providers will automatically add this if necessary."
  type        = "string"
  default     = ""
}
*/

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

variable "etcd_instance_count" {
  description = "Number of worker nodes"
  type        = "string"
}

variable "etcd_instance_type" {
  description = "Number of etcd nodes"
  type        = "string"
}

variable "etcd_instance_subnet_ids" {
  description = "List of subnet IDs within an existing VPC to deploy etcd nodes into. Required to use an existing VPC and the list must match the AZ count."
  type        = "list"
}

variable bastion_source_security_group_id {
  description = "Security group ID of the bastion server(s): inbound traffic will be allowed from this security group for maintenance"
  type = "string"
}

variable ansibleFilter {
  description = "`ansibleFilter` tag value added to all instances, to enable instance filtering in Ansible dynamic inventory"
  default     = "Kubernetes01"                                                                                                # IF YOU CHANGE THIS YOU HAVE TO CHANGE instance_filters = tag:ansibleFilter=Kubernetes01 in ./ansible/hosts/ec2.ini
}

variable kubernetes_cluster_dns {
  default = "10.31.0.1"
}

variable kubernetes_pod_cidr {
  default = "10.200.0.0/16"
}

variable default_instance_user {
  type    = "string"
  default = "ec2-user"
}

variable default_keypair_name {
  type = "string"
}
