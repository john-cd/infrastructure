variable "aws_region" {
  description = "AWS region"
}

variable "zones" {
  description = "Availability zones e.g. ["us-west-2a", "us-west-2b", "us-west-2c"]"
  type        = "list"
}
