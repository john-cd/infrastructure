# https://github.com/terraform-community-modules/tf_aws_nat

resource "aws_security_group" "nat" {
  name        = "nat_sg"
  description = "Allows NAT traffic"
  vpc_id      = "${module.vpc_main.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "nat" {
  source                 = "github.com/terraform-community-modules/tf_aws_nat"
  name                   = "${var.name}"
  instance_type          = "t2.nano"
  instance_count         = "2"
  aws_key_name           = "mykeyname"
  public_subnet_ids      = "${module.vpc.public_subnets}"
  private_subnet_ids     = "${module.vpc.private_subnets}"
  vpc_security_group_ids = ["${aws_security_group.nat.id}"]
  az_list                = "${var.azs}"
  subnets_count          = "${length(var.azs)}"
  route_table_identifier = "private"
  ssh_bastion_user       = "ubuntu"
  ssh_bastion_host       = "${aws_instance.bastion.public_ip}"
  aws_key_location       = "${file("pathtokeyfile")}"
}
