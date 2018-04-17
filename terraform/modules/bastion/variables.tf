variable "region" {
  description = "AWS region e.g. us-west-2"
  type        = "string"
}

variable "application_name" {
  description = "Unique name of the application. The S3 bucket will be named {application}-{environment}-conf (required)"
  type        = "string"
}

variable "environment_name" {
  description = "Name of the environment e.g. dev, staging, prod (required)"
  type        = "string"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = "string"
}

variable "public_subnet_ids" {
  description = "List of the public subnet IDs to launch bastion servers into"
  type        = "list"
}

## Launch Config

variable "bastion_instance_type" {
  description = "Instance type of the bastion server(s) e.g. t2.micro"
  type        = "string"
}

variable "public_key_path" {
  description = "File path to the public key file, relative to the root module. See docs/ for instructions on how to generate the key file"
  type        = "string"
}

## Autoscaling group and schedule

variable "min_size" {
  type        = "string"
  description = "Minimum number of bastion instances that can be run simultaneously"
}

variable "desired_capacity" {
  type        = "string"
  description = "The number of bastion instances that should be running in the group."
}

variable "max_size" {
  type        = "string"
  description = "Maximum number of bastion instances that can be run simultaneously"
}

variable "cooldown" {
  type        = "string"
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start."
}

variable "health_check_grace_period" {
  type        = "string"
  description = "Time, in seconds, after instance comes into service before checking health."
}

variable "scale_down_min_size" {
  type        = "string"
  description = "Minimum number of bastion instances that can be running when scaling down"
}

variable "scale_down_desired_capacity" {
  type        = "string"
  description = "The number of bastion instances that should be running when scaling down."
}

variable "scale_up_cron" {
  type        = "string"
  description = "In UTC, when to scale up the bastion servers (cron format)"
}

variable "scale_down_cron" {
  type        = "string"
  description = "In UTC, when to scale down the bastion servers (cron format)"
}
