
# EC2 Key Pair

resource "aws_key_pair" "emr_key_pair" {
  key_name   = "${var.key_name}"
  public_key = "${file(format("%s/%s", path.root, var.public_key_path))}"
}


# S3 Bucket

resource "aws_s3_bucket" "logging_bucket" {
  bucket = "${var.log_bucket_name}"
  region = "us-west-2"
 
  versioning {
    enabled = "enabled"
  }
}