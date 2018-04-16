variable "key_name" {
  description = "Name of the EC2 key pair e.g. <env>-ec2-key"
  type        = "string"
  default     = "main-ec2-key"
}

variable "public_key_path" {
  description = "File path to the public key file relative to the Terraform root module. See README for instructions on how to generate the key file."
  type        = "string"
  default     = "../credentials/main-ec2-key.pub"
}
