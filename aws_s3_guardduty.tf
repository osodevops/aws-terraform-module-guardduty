resource "aws_s3_bucket" "guardduty_s3" {
  count         = var.s3_enabled ? 1 : 0
  bucket        = "guardduty-${var.aws_region}-${var.account_id}"

  tags = merge(var.common_tags,
    {
      "Name" = "guardduty-${var.aws_region}-${var.account_id}"
    }
  )
}
resource "aws_s3_bucket_versioning" "guardduty_s3_versioning" {
  count  = var.s3_enabled ? 1 : 0
  bucket = one(aws_s3_bucket.guardduty_s3[*].id)
  versioning_configuration {
    status        = var.bucket_versioning
    mfa_delete    = var.mfa_delete_enabled
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "guardduty_s3_configuration" {
  count  = var.s3_enabled ? 1 : 0
  bucket = one(aws_s3_bucket.guardduty_s3[*].id)

  rule {
    apply_server_side_encryption_by_default {
        sse_algorithm = var.s3_sse_algorithm
    }
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "guardduty_s3_configuration" {
  count  = var.s3_enabled ? 1 : 0
  bucket = one(aws_s3_bucket.guardduty_s3[*].id)
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

resource "aws_s3_bucket_public_access_block" "guardduty_s3_bucket_access" {
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
    policy = one(data.aws_iam_policy_document.guardduty_s3_policy_document[*].json)
  }
  
data "aws_iam_policy_document" "guardduty_s3_policy_document" {
    count  = var.s3_enabled ? 1 : 0
    statement {
      sid = "AllowAccess"
  
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = ["*"]
      }
  
      actions = ["*"]
  
      resources = [
        "${one(aws_s3_bucket.guardduty_s3[*].arn)}/*",
        one(aws_s3_bucket.guardduty_s3[*].arn),
      ]
    }
  }

resource "aws_s3_bucket_policy" "guardduty_s3_policy_tls" {
  count  = var.s3_enabled ? 1 : 0
  bucket = one(aws_s3_bucket.guardduty_s3[*].id)
  policy = one(data.aws_iam_policy_document.guardduty_s3_policy_tls_document[*].json)
}

data "aws_iam_policy_document" "guardduty_s3_policy_tls_document" {
  count  = var.s3_enabled ? 1 : 0
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
      "${one(aws_s3_bucket.guardduty_s3[*].arn)}/*",
      one(aws_s3_bucket.guardduty_s3[*].arn),
    ]
  }
}