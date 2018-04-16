terraform {
  #  required_version = ">= 0.10.13"

    # https://www.terraform.io/docs/backends/types/s3.html
    backend "s3" {
		bucket = "charliedelta-config"
		key    = "dev/terraform_state"
		# encrypt = true
		region = "us-west-2"
		shared_credentials_file = "./credentials/credentials" # assumes running terraform from the root of the repo
		# profile = "default"
  }
}  

# avoid warning message
provider "template" {
  version = "~> 1.0"
}

# Specify the provider and access details
provider "aws" {
  version = ">= 1.0.0"
  region = "${var.aws_region}"
  shared_credentials_file = "${path.root}/../credentials/credentials"
  # profile = "default"
}

module "key_pair" {
  source = "../terraform/modules/key_pair"
  key_name = "dev-ec2-key"
}

module "kube" {
  source = "../terraform/modules/kube"
}

