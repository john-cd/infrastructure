# A computed default name prefix
locals {
  default_name_prefix = "${var.project_name}"
  name_prefix         = "${var.name_prefix != "" ? var.name_prefix : local.default_name_prefix}"
}

resource "aws_s3_bucket" "conf" {
  bucket = "${local.name_prefix}-conf"
  acl    = "private"

  tags {
    Name        = "${local.name_prefix}-conf"
    Environment = "${var.environment_name}"
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "main"
    enabled = true

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
}
