//
// Variables
//

variable "environment_name" { 
	description = "Name of the environment e.g. spark-dev, spark-staging..." 
	type = "string"
	default = "spark-dev" 
}

variable "region"        { 
	description = "AWS region e.g. us-west-2"
	type = "string"
	default = "us-west-2" 
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
	default = "2" 
	}

variable "instance_type" { 
	description = "Instance type"
	type = "string"
	default = "t2.micro" 
}

variable "key_name"      { 
	description = "Name of the EC2 instance key"
	type = "string"
	default = "spark-ec2-key" 
}

variable "public_key_path" {
  description = "File path to the public key file relative to the Terraform root module. See README for instructions on how to generate the key file."
  type        = "string"
  default     = "../../credentials/main-ec2-key.pub"
}

variable "bastion_security_group_id"  {
	description = "ID of the security group associated with bastion servers (required)"
	type ="string" 
	}

variable "log_bucket_name"  {
	description = "Unique name of the S3 bucket that will collect logs (required)"
	type ="string" 
	}	
	
	
