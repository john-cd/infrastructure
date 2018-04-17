output "backend_bucket_id" {
	value = "${aws_s3_bucket.backend_bucket.id}"
}

output "backend_bucket_arn" {
	value = "${aws_s3_bucket.backend_bucket.arn}"
}	

output "backend_bucket_domain_name " {
	value = "${aws_s3_bucket.backend_bucket.bucket_domain_name}"
}
