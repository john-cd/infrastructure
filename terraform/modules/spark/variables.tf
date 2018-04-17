//
// Variables
//

variable "region"        { 
	description = "AWS region e.g. us-west-2"
	type = "string"
}

variable "application_name" {
  description = "Unique name of the application"
  type        = "string"
}

variable "environment_name" { 
	description = "Name of the environment e.g. spark-dev, spark-staging..." 
	type = "string"
}

variable "vpc_id"    { 
	description = "ID of the VPC to create the Spark cluster into (required)" 
	type = "string"
	}

variable "main_subnet_id" { 
	description = "ID of the subnet the Spark cluster will be created into (required)"
	type ="string" 
}

variable "spark_slave_count" {
    type = "string"

}

variable "instance_type" { 
	description = "Instance type e.g. t2.micro"
	type = "string"
}

variable "key_name"      { 
	description = "Name of the (main) EC2 instance key e.g. spark-ec2-key"
	type = "string" 
}

variable "public_key_path" {
  description = "File path to the public key file, relative to the Terraform root module. See docs/ for instructions on how to generate the key file."
  type        = "string"
}

variable "bastion_security_group_id"  {
	description = "ID of the security group used for commnication between bastion servers and internal subnets (required)"
	type ="string" 
}

variable "log_bucket_id" {
  description = "ID of the S3 bucket used for log collection"
  type ="string" 
}
	
	
