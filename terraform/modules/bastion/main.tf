# Create a security group for communication between the bastion servers and the outside world
# https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/1.9.0
# https://github.com/terraform-aws-modules/terraform-aws-security-group/tree/master/modules/ssh

module "ssh-security-group" {
  source  = "terraform-aws-modules/security-group/aws//modules/ssh"
  version = "1.9.0"

  name        = "${var.application_name}-${var.environment_name}-ssh-sg"
  description = "Security group for SSH, all world open"
  vpc_id      = "${var.vpc_id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  create              = true

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-ssh-sg"
    Application = "${var.application_name}"
    Environment = "${var.environment_name}"
  }
}

## Create an internal-only security group for communication between bastion servers and private subnets
## It will serve as a route table source for e.g. Kubernetes and Spark cluster machines

data "aws_vpc" "current_vpc" {
  id = "${var.vpc_id}"
}

module "bastion_source_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "1.9.0"

  create      = true
  name        = "${var.application_name}-${var.environment_name}-bastion-source-sg"
  description = "Security group for communication between bastion servers and private subnets"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-bastion-source-sg"
    Application = "${var.application_name}"
    Environment = "${var.environment_name}"
  }

  # Default CIDR blocks, which will be used for all ingress rules in this module. Typically these are CIDR blocks of the VPC.
  # If this is not specified then no CIDR blocks will be used.
  ingress_cidr_blocks = ["${data.aws_vpc.current_vpc.cidr_block}"]

  ingress_ipv6_cidr_blocks = ["${data.aws_vpc.current_vpc.ipv6_cidr_block}"]

  # Open for all CIDRs defined in ingress_cidr_blocks
  ingress_rules = ["all-all"]

  # Open for self (rule or from_port+to_port+protocol+description)
  /* TODO add a rule to allow self ingress
  ingress_with_self = [{
    rule = "all-all",
	description = "all-all"
  }]
  */

  # Default CIDR blocks, which will be used for all egress rules in this module. Typically these are CIDR blocks of the VPC.
  # If this is not specified then no CIDR blocks will be used.
  egress_cidr_blocks = ["${data.aws_vpc.current_vpc.cidr_block}"]

  egress_ipv6_cidr_blocks = ["${data.aws_vpc.current_vpc.ipv6_cidr_block}"]

  # Open for all CIDRs defined in egress_cidr_blocks
  egress_rules = ["all-all"]
}
