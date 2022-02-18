resource "aws_s3_bucket" "guardduty_s3" {
  count         = var.s3_enabled ? 1 : 0
  bucket        = var.s3_bucket_name
  force_destroy = var.s3_bucket_force_destroy

  versioning {
    enabled     = var.bucket_versioning
    mfa_delete  = var.mfa_delete_enabled
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.s3_sse_algorithm
      }
    }
  }

  tags = merge(var.common_tags,
    {
      "Name" = "${var.environment}-${var.s3_bucket_name}-S3"
    }
  )

  #lifecycle rules for non-current versions (defaults to on)
  lifecycle_rule {
    enabled = var.enable_lifecycle
    id      = "default"

    abort_incomplete_multipart_upload_days = 14

    transition {
      days          = var.current_ia_transition_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.current_glacier_transition_days
      storage_class = "GLACIER"
    }

    noncurrent_version_transition {
      days          = var.noncurrent_ia_transition_days
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = var.noncurrent_glacier_transition_days
      storage_class = "GLACIER"
    }

    expiration {
      expired_object_delete_marker = var.delete_expired_objects
      days                         = var.current_version_expiration_days
    }
  }
}

resource "aws_s3_bucket_acl" "guardduty_s3_acl" {
  count  = var.s3_enabled ? 1 : 0
  bucket = one(aws_s3_bucket.guardduty_s3[*].id)
  acl    = var.s3_bucket_acl
}
resource "aws_s3_bucket_public_access_block" "bucket_access" {
  count  = var.s3_enabled ? 1 : 0
  bucket = one(aws_s3_bucket.guardduty_s3[*].id)

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_policy" "guardduty_s3_policy" {
    count  = var.s3_enabled ? 1 : 0
    bucket = one(aws_s3_bucket.guardduty_s3[*].id)

    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "AWS": "*"
          },
          "Action": [ "s3:*" ],
          "Resource": [
            "${one(aws_s3_bucket.guardduty_s3[*].arn)}",
            "${one(aws_s3_bucket.guardduty_s3[*].arn)}/*"
          ]
        }
      ]
    })
}