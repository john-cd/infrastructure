## Create a S3 bucket to host a static website

resource "aws_s3_bucket" "web_bucket" {
  bucket = "${var.bucket_name}" # needs to be the same than the website domain name
  region = "${var.region}"

  acl = "public-read"

  tags {
    Name        = "${var.bucket_name}"
    Application = "${var.application_name}"
    Environment = "${var.environment_name}"
  }

  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  lifecycle_rule {
    id      = "website"
    enabled = true

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

/*  TODO fix
  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${var.application_name}-${var.environment_name}-web/*"]
    }
  ]
}
EOF  
*/


/* TODO
logging {
target_bucket = "${var.log_bucket_id}"
target_prefix = "conf_bucket/"
}
*/


/*	
routing_rules = [{
"Condition": {
	"KeyPrefixEquals": "docs/"
},
"Redirect": {
	"ReplaceKeyPrefixWith": "documents/"
}
}]
}
*/


/* TODO
cors_rule {
allowed_headers = ["*"]
allowed_methods = ["PUT", "POST"]
allowed_origins = ["https://s3-website-test.hashicorp.com"]
expose_headers  = ["ETag"]
max_age_seconds = 3000
}
*/

