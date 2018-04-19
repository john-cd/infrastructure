## Create Route53 DNS records
##
## https://medium.com/@maxbeatty/using-terraform-to-manage-dns-records-b338f42b50dc
## https://www.terraform.io/docs/providers/aws/d/route53_zone.html

## Allows the use of another AWS account for Route 53 

provider "aws" {
  version = ">= 1.0.0"
  region  = "${var.region}"

  shared_credentials_file = "${path.root}/${var.credentials_file}"
  profile                 = "${var.credentials_profile}"
}

## The parent zone should already exist 

data "aws_route53_zone" "parent" {
  name = "${var.domain_name}"
}

## Create subdomain records 
## TTL for all alias records is 60 seconds, you cannot change this, therefore ttl has to be omitted in alias records.

resource "aws_route53_record" "subdomain" {
  zone_id = "${aws_route53_zone.parent.zone_id}"
  name    = "${var.subdomain}.${data.aws_route53_zone.parent.zone_id}"
  type    = "A"                                                        # TODO need a A or CNAME record??

  alias {
    name                   = "${var.elb_dns_name}"
    zone_id                = "${var.elb_zone_id}"  # The canonical hosted zone ID of the ELB
    evaluate_target_health = false
  }
}

/* Other Examples:

variable "ttl" {
	description = "time to live"
   type = "string"
   default = "3600"
}

## A record to a public IP
resource "aws_route53_record" "child" {
  zone_id = "${data.aws_route53_zone.parent.zone_id}"
  name = "${child}.${data.aws_route53_zone.parent.zone_id}"
  type = "A"
  ttl = "${var.ttl}"
  records = ["${aws_instance.baz1.public_ip}"]
}

## CNAME record to an ELB

variable "elb_cname" {
  description = "CNAME for the ELB"
}

resource "aws_route53_record" "child" {
  zone_id = "${child}.${data.aws_route53_zone.parent.zone_id}"
  name = "${var.elb_cname}"
  type = "CNAME"
  ttl = "${var.ttl}"
  records = ["${aws_elb.my-elb.dns_name}"]
}

*/

