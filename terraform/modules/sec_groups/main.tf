module "http-security-group" {
  source  = "terraform-aws-modules/security-group/aws/http"
  version = "1.9.0"

  name        = "http_sg"
  description = "Security group with HTTP ports open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id      = "${var.vpc_id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  create              = true
}
