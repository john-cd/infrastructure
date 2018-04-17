output "conf_bucket_id" {
  value = "${aws_s3_bucket.conf_bucket.id}"
}

output "conf_bucket_arn" {
  value = "${aws_s3_bucket.conf_bucket.arn}"
}

output "conf_bucket_domain_name " {
  value = "${aws_s3_bucket.conf_bucket.bucket_domain_name}"
}
