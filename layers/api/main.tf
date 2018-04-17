terraform {
  required_version = ">= 0.10.13"

  # Remote backend 
  # Can be overriden by environment-specific configuration in config/backend-*.conf 
  # https://www.terraform.io/docs/backends/types/s3.html
  # https://github.com/BWITS/terraform-best-practices
  backend "s3" {
    region = "us-west-2"            # region of the remote backend S3 bucket
    bucket = "charliedelta-backend"
    key    = "api/dev/dev.tfstate"

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
  version = ">= 1.0.0"
  region  = "${var.region}"

  shared_credentials_file = "${path.root}/../../credentials/credentials"

  # profile = "default"
}

## Create S3 buckets for logs, configuration data and static website data

module "log_bucket" {
  source           = "../../terraform/modules/log_bucket"
  region           = "${var.region}"
  application_name = "${var.application_name}"
  environment_name = "${var.environment_name}"
}

module "conf_bucket" {
  source           = "../../terraform/modules/conf_bucket"
  region           = "${var.region}"
  application_name = "${var.application_name}"
  environment_name = "${var.environment_name}"
  log_bucket_id    = "${module.log_bucket.log_bucket_id}"
}

module "web_bucket" {
  source           = "../../terraform/modules/static_website_bucket"
  region           = "${var.region}"
  application_name = "${var.application_name}"
  environment_name = "${var.environment_name}"
  log_bucket_id    = "${module.log_bucket.log_bucket_id}"
}

## Create a VPC, subnets, IGW, egress GW, routes...

module "main_network" {
  source           = "../../terraform/modules/network"
  application_name = "${var.application_name}"
  environment_name = "${var.environment_name}"
  vpc_cidr         = "${var.vpc_cidr}"
  zones            = ["${var.zones}"]
}

## Create bastion server(s)

data "aws_iam_account_alias" "current" {}

module "bastion" {
  source = "../../terraform/modules/bastion"

  region                = "${var.region}"
  application_name      = "${var.application_name}"
  environment_name      = "${var.environment_name}"
  vpc_id                = "${module.main_network.vpc_id}"
  public_subnet_ids     = "${module.main_network.public_subnets}"
  bastion_instance_type = "t2.micro"
  public_key_path       = "${var.public_key_path}"

  # auto-scaling group
  desired_capacity          = 1
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300 # seconds
  cooldown                  = 90  # seconds

  # schedule
  scale_up_cron               = "0 9 * * 1-5"  # 9AM weekdays 
  scale_down_cron             = "0 18 * * 1-5" # 6PM weekdays
  scale_down_desired_capacity = 0
  scale_down_min_size         = 0
}

## Create a key pair to access EC2 instances

resource "aws_key_pair" "main_ec2_key" {
  key_name   = "${var.application_name}-${var.environment_name}-api-ec2-key"
  public_key = "${file(format("%s/%s", path.root, var.public_key_path))}"
}

## Install Kubernetes

/* TODO

module "kube" {
  source = "../../terraform/modules/kube"

  region               = "${var.region}"
  application_name     = "${var.application_name}"
  environment_name     = "${var.environment_name}"
  base_domain_name     = ""
  vpc_id               = "${module.main_network.vpc_id}"
  master_count         = "1"
  master_instance_type = "t2.micro"
  master_subnet_ids    = ["${module.main_network.private_subnets}"]
  worker_count         = "1"
  worker_instance_type = "t2.micro"
  worker_subnet_ids    = ["${module.main_network.private_subnets}"]

  ssh_key_name = "${aws_key_pair.main_ec2_key.name}"

  admin_email    = "${var.admin_email}"
  admin_password = "${var.admin_password}"
}

*/