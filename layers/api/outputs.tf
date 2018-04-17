## Most of these outputs are used by the "bigdata" layer

output "region" {
  description = "AWS region e.g. us-west-2"
  value       = "${var.region}"
}

output "application_name" {
  description = "Unique name of the application"
  value       = "${var.application_name}"
}

output "environment_name" {
  description = "Environment name e.g. dev, staging, prod"
  value       = "${var.environment_name}"
}

output "main_EC2_key_name" {
  description = "Name of the main EC2 key"
  value       = "${aws_key_pair.main_ec2_key.key_name}"
}

output "public_key_path" {
  description = "File path to the public key file, relative to the root module. See docs/ for instructions on how to generate the key file"
  value       = "${var.public_key_path}"
}

output "bastion_source_security_group_id" {
  description = "ID of the SSH security group for communication between bastion servers and internal subnets"
  value       = "${module.bastion.bastion_source_security_group_id}"
}

output "log_bucket_id" {
  description = "ID of the S3 bucket used for log collection"
  value       = "${module.log_bucket.log_bucket_id}"
}
