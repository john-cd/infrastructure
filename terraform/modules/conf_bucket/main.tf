## Create a S3 bucket for configuration data

resource "aws_s3_bucket" "conf_bucket" {
  bucket = "${var.application_name}-${var.environment_name}-conf"
  region = "${var.region}"

  acl = "private"

  tags {
    Name        = "${var.application_name}-${var.environment_name}-conf"
    Application = "${var.application_name}"
    Environment = "${var.environment_name}"
  }

  versioning {
    enabled = true

    # mfa_delete = true
  }

  lifecycle_rule {
    id                                     = "main"
    enabled                                = true
    abort_incomplete_multipart_upload_days = 10

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

  /* TODO
  logging {
    target_bucket = "${var.log_bucket_id}"
    target_prefix = "conf_bucket/"
  }
  */

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
