resource "aws_s3_bucket" "kinesis_bucket" {
  count         = var.kinesis_enabled ? 1 : 0
  bucket        = "guardduty-kinesis-${var.aws_region}-${var.account_id}"
  
  tags = merge(var.common_tags,
    {
      "Name" = "${var.environment}-guardduty-kinesis-${var.aws_region}-${var.account_id}-S3"
    }
  )

  expiration {
    expired_object_delete_marker = var.delete_expired_objects
    days                         = var.current_version_expiration_days
  }
}

resource "aws_s3_bucket_versioning" "kinesis_bucket_versioning" {
  count  = var.kinesis_enabled ? 1 : 0
  bucket = one(aws_s3_bucket.kinesis_bucket[*].id)
  versioning_configuration {
    status        = var.bucket_versioning
    mfa_delete    = var.mfa_delete_enabled
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kinesis_bucket_configuration" {
  count  = var.kinesis_enabled ? 1 : 0
  bucket = one(aws_s3_bucket.kinesis_bucket[*].id)

  rule {
    apply_server_side_encryption_by_default {
        sse_algorithm = var.s3_sse_algorithm
    }
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "kinesis_bucket_configuration" {
  count  = var.kinesis_enabled ? 1 : 0
  bucket = one(aws_s3_bucket.kinesis_bucket[*].id)
  name   = var.intelligent_tiering_configuration_name 

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = var.deep_archive_access_days
  }
  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = var.archieve_access_days
  }
}

resource "aws_s3_bucket_public_access_block" "kinesis_bucket_access" {
  count  = var.kinesis_enabled ? 1 : 0
  bucket = one(aws_s3_bucket.kinesis_bucket[*].id)

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}


resource "aws_s3_bucket_policy" "kinesis_bucket_policy_tls" {
  count  = var.kinesis_enabled ? 1 : 0
  bucket = one(aws_s3_bucket.kinesis_bucket[*].id)
  policy = data.aws_iam_policy_document.kinesis_bucket_policy_tls_document.json
}

data "aws_iam_policy_document" "kinesis_bucket_policy_tls_document" {
  statement {
    sid = "TLSEnabled"

    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test = "Bool"
      variable = "aws:SecureTransport"
      values = ["false"]
    }

    actions = ["*"]

    resources = [
      "${aws_s3_bucket.kinesis_bucket.arn}/*",
      aws_s3_bucket.kinesis_bucket.arn,
    ]
  }
}

resource "aws_s3_bucket_policy" "kinesis_bucket_policy" {
    count  = var.kinesis_enabled ? 1 : 0
    bucket = one(aws_s3_bucket.kinesis_bucket[*].id)
    policy = data.aws_iam_policy_document.kinesis_bucket_policy_document.json
  }
  
data "aws_iam_policy_document" "kinesis_bucket_policy_document" {
    statement {
      sid = "AllowAccess"
  
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = ["*"]
      }
  
      actions = ["*"]
  
      resources = [
        "${aws_s3_bucket.kinesis_bucket.arn}/*",
        aws_s3_bucket.kinesis_bucket.arn,
      ]
    }
  }