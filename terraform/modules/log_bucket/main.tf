## Create a S3 Bucket for logs

resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.application_name}-${var.environment_name}-logs"
  region = "${var.region}"

  tags {
    Name        = "${var.application_name}-${var.environment_name}-logs"
    Application = "${var.application_name}"
    Environment = "${var.environment_name}"
  }

  versioning {
    enabled = true

    # mfa_delete = true
  }

  lifecycle_rule {
    id                                     = "logs"
    enabled                                = true
    abort_incomplete_multipart_upload_days = 10

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days                         = 90
      expired_object_delete_marker = true
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
        sse_algorithm = "AES256"
      }
    }
  }
}
