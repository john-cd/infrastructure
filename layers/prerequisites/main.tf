## Prerequisites
## Create a S3 bucket that serve as a remote backend for Terraform
## This plan is intended to be run LOCALLY ONCE

terraform {
  required_version = ">= 0.10.13"
}

## Avoid warning message
provider "template" {
  version = "~> 1.0"
}

## Specify the provider and access details
provider "aws" {
  version = ">= 1.0.0"
  region  = "${var.region}"

  shared_credentials_file = "${path.root}/../../credentials/credentials"

  # profile = "default"
}

## Create a S3 bucket

module "remote_backend_bucket" {
  source = "../../terraform/modules/remote_backend_bucket"

  region           = "${var.region}"
  application_name = "${var.application_name}"
}
