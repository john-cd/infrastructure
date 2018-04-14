# https://github.com/terraform-aws-modules/terraform-aws-vpc

data "template_file" "private_zone_cidr" {
  # Render the template once for each zone
  count    = "${length(var.zones)}"
  template = "$${cidrsubnet(cidr, 8, idx)}"

  vars {
    # count.index tells us the index of the zone
    idx  = "${count.index}"
    cidr = "${var.vpc_cidr}"
  }
}

data "template_file" "public_zone_cidr" {
  # Render the template once for each zone
  count    = "${length(var.zones)}"
  template = "$${cidrsubnet(cidr, 8, idx)}"

  vars {
    # count.index tells us the index of the zone
    idx  = "${count.index + 100}"
    cidr = "${var.vpc_cidr}"
  }
}

module "vpc_main" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.30.0"

  create_vpc = true

  name = "${var.environment_name}"
  cidr = "${var.vpc_cidr}"

  azs             = "${var.zones}"
  private_subnets = "${data.template_file.private_zone_cidr.*.rendered}"
  public_subnets  = "${data.template_file.public_zone_cidr.*.rendered}"

  map_public_ip_on_launch = false

  enable_nat_gateway = false
  single_nat_gateway = true  # Should be true if you want to provision a single shared NAT Gateway across all of your private networks

  enable_vpn_gateway = false

  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = false

  create_database_subnet_group = false

  vpc_tags = {
    Name = "${var.environment_name}"
  }

  tags = {
    Environment = "${var.environment_name}"
  }
}

# create engress gateway + route table entries for it

module "ipv6" {
  source = "../ipv6"

  vpc_id                  = "${module.vpc_main.vpc_id}"
  private_route_table_ids = "${module.vpc_main.private_route_table_ids}"
}