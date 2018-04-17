# create an egress only IGW and route table entries

resource "aws_egress_only_internet_gateway" "egress" {
  vpc_id = "${var.vpc_id}"
}

resource "aws_route" "route_to_egress" {
  count                       = 1                                               # TODO find work around for   https://github.com/hashicorp/terraform/issues/12570
  route_table_id              = "${var.private_route_table_ids[count.index]}"
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = "${aws_egress_only_internet_gateway.egress.id}"
}


