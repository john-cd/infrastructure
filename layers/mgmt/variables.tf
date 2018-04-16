variable "aws_region" {
  description = "AWS region"
  type        = "string"
  default = "us-west-2"
}

variable "zones" {
  description = "Availability zones e.g. [\"us-west-2a\", \"us-west-2b\", \"us-west-2c\"]"
  type        = "list"
  default      = ["us-west-2a", "us-west-2b", "us-west-2c"]
}
