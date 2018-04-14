# use with an import:
# terraform import aws_vpc.main  <vpc id>

# enable IPv6 in the selected VPC
resource "aws_vpc" "main" {
  assign_generated_ipv6_cidr_block = true
}
