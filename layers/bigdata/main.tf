terraform {
  required_version = ">= 0.10.13"

  # Remote backend for the bigdata layer
  # The environment-specific configuration is in config/backend-*.conf 
  # https://www.terraform.io/docs/backends/types/s3.html
  # https://github.com/BWITS/terraform-best-practices
  backend "s3" {
    region = "us-west-2"
    bucket = "charliedelta-backend"
    key    = "bigdata/dev/dev.tfstate"

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

## Retrieve data from the API layer remote backend
## We will use the same VPC and subnets

data "terraform_remote_state" "api" {
  backend = "s3"

  config {
    bucket = "${var.api_remote_backend_bucket}"
    key    = "api/${var.environment_name}/${var.environment_name}.tfstate"
    region = "${var.api_remote_backend_region}"
  }
}

## Specify the provider and access details
provider "aws" {
  version = ">= 1.0.0"
  region  = "${data.terraform_remote_state.api.region}"

  shared_credentials_file = "${path.root}/../../credentials/credentials"

  # profile = "default"
}

## Install Apache Spark

module "spark" {
  source = "../../terraform/modules/spark"

  region                    = "${data.terraform_remote_state.api.region}"
  application_name          = "${data.terraform_remote_state.api.application_name}"
  environment_name          = "${data.terraform_remote_state.api.environment_name}"
  vpc_id                    = "${data.terraform_remote_state.api.vpc_id}"
  main_subnet_id            = "${split(",", data.terraform_remote_state.api.data_subnets)}"         # TODO
  instance_type             = "t2.micro"
  spark_slave_count         = "${var.spark_slave_count}"
  key_name                  = "${data.terraform_remote_state.api.main_EC2_key_name}"
  public_key_path           = "${data.terraform_remote_state.api.public_key_path}"
  bastion_security_group_id = "${data.terraform_remote_state.api.bastion_source_security_group_id}"
  log_bucket_id             = "${data.terraform_remote_state.api.log_bucket_id}"
}
