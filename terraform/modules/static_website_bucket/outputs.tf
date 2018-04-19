output "web_bucket_id" {
  value = "${aws_s3_bucket.web_bucket.id}"
}

output "web_bucket_arn" {
  value = "${aws_s3_bucket.web_bucket.arn}"
}

output "web_bucket_domain_name " {
  value = "${aws_s3_bucket.web_bucket.bucket_domain_name}"
}

output "website_endpoint" {
  value = "${aws_s3_bucket.web_bucket.website_endpoint}"
}

output "website_domain" {
  value = "${aws_s3_bucket.web_bucket.website_domain}"
}

output "hosted_zone_id" {
  value = "${aws_s3_bucket.web_bucket.hosted_zone_id}"
}
