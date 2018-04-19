## Create basic index.html and error.html files

locals {
  path_to_index = "${path.module}/html/index.html"
  path_to_error = "${path.module}/html/error.html"
}

resource "aws_s3_bucket_object" "index" {
  bucket = "${aws_s3_bucket.web_bucket.id}"
  key    = "index.html"
  source = "${local.path_to_index}"
  etag   = "${md5(file(local.path_to_index))}"
}

resource "aws_s3_bucket_object" "error" {
  bucket = "${aws_s3_bucket.web_bucket.id}"
  key    = "error.html"
  source = "${local.path_to_error}"
  etag   = "${md5(file(local.path_to_error))}"
}
