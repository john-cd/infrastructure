terraform {
  #  required_version = ">= 0.10.13"

    # https://www.terraform.io/docs/backends/types/s3.html
    backend "s3" {
		bucket = "charliedelta-config"
		key    = "terraform_state"
		encrypt = true
		region = "us-west-2"
		shared_credentials_file = "./credentials/credentials" # assumes running terraform from the root of the repo
		# profile = "default"
  }
}  

# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"

  # version = ">= 1.0.0"
  shared_credentials_file = "${path.root}/../credentials/credentials"

  # profile = "default"
}

module "key_pair" {
  source = "../terraform/modules/key_pair"
}


/*

module "kube" {
  source = "../terraform/modules/kube"
}



module "iam_automation" {
  source = "../terraform/modules/iam_automation"
}

module "vpc_main" {
  source = "../terraform/modules/vpc_main"
}
*/

/*
module "vpc_management" {
  source = "../terraform/modules/vpc_main"
  environment_name = "mgmt"
  vpc_cidr = "10.16.0.0/16"
}
*/

