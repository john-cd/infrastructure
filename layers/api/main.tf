terraform {
  required_version = ">= 0.10.13"

  # Remote backend 
  # The environment-specific configuration is in config/backend-*.conf 
  # https://www.terraform.io/docs/backends/types/s3.html
  # https://github.com/BWITS/terraform-best-practices
  backend "s3" {
    region = "us-west-2"
	bucket = "charliedelta-config"
	key    = "kube_layer/dev/dev.tfstate"
	#encrypt = true

	#kms_key_id = "alias/terraform"
	#dynamodb_table = "terraform-lock"

	shared_credentials_file = "credentials/credentials"
	#profile = "default"
  }
}

# Avoid warning message
provider "template" {
  version = "~> 1.0"
}

# Specify the provider and access details
provider "aws" {
  version                 = ">= 1.0.0"
  region                  = "${var.aws_region}"
  shared_credentials_file = "${path.root}/../credentials/credentials"

  # profile = "default"
}

module "key_pair" {
  source   = "../../terraform/modules/key_pair"
  key_name = "dev-ec2-key"
}

module "kube" {
  source = "../../terraform/modules/kube"
}
