terraform {
  required_version = ">= 0.10.13"

  # https://www.terraform.io/docs/backends/types/s3.html
  backend "s3" {
    bucket = "charliedelta-config"
    key    = "mgmt/terraform_state"

    # encrypt = true
    region                  = "us-west-2"
    shared_credentials_file = "./credentials/credentials" # assumes running terraform from the root of the repo

    # profile = "default"
  }
}

# Specify the provider and access details
provider "aws" {
  region                  = "${var.aws_region}"
  version                 = ">= 1.0.0"
  shared_credentials_file = "${path.root}/../credentials/credentials"

  # profile = "default"
}

# Basic account setup
# https://registry.terraform.io/modules/zoitech/account/aws/0.0.4?tab=inputs
# https://github.com/zoitech/terraform-aws-account

module "account" {
  source       = "zoitech/account/aws"
  version      = "0.0.4"
  account_name = "sjncd2000"
  aws_region   = "${var.aws_region}"

  ## Password settings
  password_hard_expiry = false
  password_max_age = 180
  password_min_length = 10
  password_reuse_prevention = 10

  ## CloudTrail settings  
  trail_name = "mgmt"
  # trail_bucketname_create = 1
  # trail_bucketname = "" # Will defaults to <account-id>-logs.
  # trail_bucket_default_encryption = "AES256"

  # tags = {}
}

# Create users and groups
/*
module "iam_automation" {
  source = "../terraform/modules/iam_automation"
}
*/

# Create a management VPC

module "vpc_management" {
  source           = "../terraform/modules/vpc_main"
  environment_name = "mgmt"
  vpc_cidr         = "10.16.0.0/16"
}

# Create a security group for the bastion servers
# https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/1.9.0
# https://github.com/terraform-aws-modules/terraform-aws-security-group/tree/master/modules/ssh

module "ssh-security-group" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"
  version = "1.9.0"

  name        = "ssh_sg"
  description = "Security group for SSH, all world open"
  vpc_id      = "${module.vpc_management.vpc_id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  create              = true
}


data "aws_iam_account_alias" "current" {}


# Create an auto-scaling group of Bastion servers, allowing SSH access to the private EC2 instances
# https://registry.terraform.io/modules/kurron/bastion/aws/0.9.0
# https://github.com/kurron/terraform-aws-bastion

module "bastion" {
  source  = "kurron/bastion/aws"
  version = "0.9.0"

  # register a ec2 key
  ssh_key_name   = ""                                                        # not used  
  public_ssh_key = "${file("${path.root}/../credentials/main-ec2-key.pub")}"

  # launch configuration
  region        = "us-west-2"
  instance_type = "t2.micro"

  # auto-scaling group
  desired_capacity          = 1
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  cooldown                  = 90  # seconds

  # auto-scaling group tags
  creator     = "${data.aws_iam_account_alias.current}"
  environment = "mgmt"
  project     = "mgmt"
  freetext    = ""

  # schedule
  scale_up_cron               = "0 9 * * 1-5"  # 9AM weekdays 
  scale_down_cron             = "0 18 * * 1-5" # 6PM weekdays
  scale_down_desired_capacity = 0
  scale_down_min_size         = 0

  security_group_ids = ["${module.ssh-security-group.this_security_group_id}"]

  subnet_ids = ["${module.vpc_management.public_subnets}"]
}
