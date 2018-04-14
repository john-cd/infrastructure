output "egress_only_gateway_id" {
  value = "${aws_egress_only_internet_gateway.egress.id}"
}
