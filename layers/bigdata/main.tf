terraform {
  required_version = ">= 0.10.13"

  # Remote backend 
  # The environment-specific configuration is in config/backend-*.conf 
  # https://www.terraform.io/docs/backends/types/s3.html
  # https://github.com/BWITS/terraform-best-practices
  backend "s3" {
    region = "us-west-2"
	bucket = "charliedelta-config"
	key    = "kube_layer/bigdata/dev/dev.tfstate"
	#encrypt = true

	#kms_key_id = "alias/terraform"
	#dynamodb_table = "terraform-lock"

	shared_credentials_file = "credentials/credentials"
	#profile = "default"
  }
}

## Avoid warning message
provider "template" {
  version = "~> 1.0"
}

## Specify the provider and access details
provider "aws" {
  version                 = ">= 1.0.0"
  region                  = "${var.aws_region}"
  
  shared_credentials_file = "${path.root}/../credentials/credentials"
  # profile = "default"
}

## Install Apache Spark

module "spark" {
  source = "${format("%s/../../terraform/modules/spark", path.root)}"
}


