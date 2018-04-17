terraform {
  required_version = ">= 0.10.13"

  # Remote backend 
  # Can be overriden by passing backend-*.conf 
  # https://www.terraform.io/docs/backends/types/s3.html
  # https://github.com/BWITS/terraform-best-practices
  backend "s3" {
    region = "us-west-2"
    bucket = "charliedelta-backend"
    key    = "mgmt/mgmt.tfstate"
    # encrypt = true

    shared_credentials_file = "./credentials/credentials" # assumes running terraform from the root of the repo
    # profile = "default"
  }
}

## Avoid warning message
provider "template" {
  version = "~> 1.0"
}

## Specify the provider and access details

provider "aws" {
  region  = "${var.aws_region}"
  version = ">= 1.0.0"

  shared_credentials_file = "${path.root}/../../credentials/credentials"
  # profile = "default"
}

## Create a CloudTrail log bucket

/* TODO do we need?
module "log_bucket" {
  source           = "../../terraform/modules/log_bucket"
  region           = "${var.region}"
  application_name = "mgmt"
  environment_name = "$all"
}
*/

## Gather info about current account

data "aws_iam_account_alias" "current" {}

# TODO avoid setting alias if it is already set

## Basic account setup
## Derived from
## https://registry.terraform.io/modules/zoitech/account/aws/0.0.4?tab=inputs
## https://github.com/zoitech/terraform-aws-account

module "account" {
  source       = "../../terraform/modules/account"
  version      = "0.0.4"
  account_name = "${var.account_name}"
  aws_region   = "${var.aws_region}"

  ## Password settings
  password_hard_expiry      = false
  password_max_age          = 180
  password_min_length       = 10
  password_reuse_prevention = 10

  ## CloudTrail settings  
  trail_name = "mgmt"

  # TODO
  # trail_bucketname_create = 1
  # trail_bucketname = "" # Will defaults to <account-id>-logs.
  # trail_bucket_default_encryption = "AES256"

  /* TODO
  tags = {
    Name = "${var.application_name}-${var.environment_name}"
	Application = "${var.application_name}"
	Environment = "${var.environment_name}"
  }	
  */
}

## Create users and groups

/* TODO fix
module "users_and_groups" {
  source = "../../terraform/modules/users"
}
*/

/* TODO do we need? 

## Create a management VPC, subnets, IGW, egress GW, routes...

module "mgmt_network" {
  source           = "../../terraform/modules/network"
  environment_name = "mgmt"
  vpc_cidr         = "10.16.0.0/16"
  zones            = ["${var.zones}"]
}

*/
