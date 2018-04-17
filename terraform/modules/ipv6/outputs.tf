output "egress_only_internet_gateway_id" {
  description = "ID of the egress only internet gateway"
  value = "${aws_egress_only_internet_gateway.egress.id}"
}
