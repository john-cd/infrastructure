
## Create a S3 bucket that will serve as a remote backend for Terraform

resource "aws_s3_bucket" "backend_bucket" {

  bucket = "${var.application_name}-backend"
  region = "${var.region}"
   
  acl    = "private"

  tags {
    Name        = "${var.application_name}-backend"
	Application = "${var.application_name}"
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "main"
    enabled = true
	abort_incomplete_multipart_upload_days = 7
	  
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = 60
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = 90
    }
  }
  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
}
