
# Create a security group for the NAT instance

resource "aws_security_group" "nat_sg" {
  name        = "nat_sg"
  description = "Allows NAT traffic"
  vpc_id      = "${var.vpc_id}"

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

# Create a NAT instance
# https://github.com/terraform-community-modules/tf_aws_nat

module "nat" {
  source                 = "github.com/terraform-community-modules/tf_aws_nat"
  name                   = "${var.instance_name}"
  instance_type          = "t2.nano"
  instance_count         = "1"
  aws_key_name           = "${var.aws_key_name}"
  public_subnet_ids      = "${var.public_subnet_ids}"
  private_subnet_ids     = "${var.private_subnet_ids}"
  vpc_security_group_ids = ["${aws_security_group.nat_sg.id}"]
  az_list                = "${var.zones}"
  subnets_count          = "${length(var.zones)}"
  route_table_identifier = "private"
  ssh_bastion_user       = "ubuntu"
  ssh_bastion_host       = "${aws_instance.bastion.public_ip}"
  aws_key_location       = "${file("pathtokeyfile")}"
}
