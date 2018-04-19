## Create a Route53 DNS record pointing to a S3 bucket
##
## https://medium.com/@maxbeatty/using-terraform-to-manage-dns-records-b338f42b50dc
## https://www.terraform.io/docs/providers/aws/d/route53_zone.html
##
## https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/RoutingToS3Bucket.html

## Allows the use of another AWS account for Route 53 

provider "aws" {
  version = ">= 1.0.0"
  region  = "${var.region}"

  shared_credentials_file = "${var.credentials_file}"
  profile                 = "${var.credentials_profile}"
}

## The parent zone should already exist 

data "aws_route53_zone" "parent" {
  name = "${var.zone_domain_name}"
}

## Create subdomain records

resource "aws_route53_record" "subdomain" {
  zone_id = "${data.aws_route53_zone.parent.zone_id}"
  name    = "${var.subdomain}.${data.aws_route53_zone.parent.zone_id}"
  type    = "A"

  alias {
    name                   = "${var.website_domain}"
    zone_id                = "${var.hosted_zone_id}"
    evaluate_target_health = false
  }
}
