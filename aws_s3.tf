resource "aws_s3_bucket" "guardduty_s3" {
  count         = "${var.enabled ? 1 : 0}"
  bucket        = "${var.s3_bucket_name}"
  key           = "${var.prefix}"
  policy        = "${var.s3_bucket_policy}"
  acl           = "${var.s3_bucket_acl}"
  force_destroy = "${var.s3_bucket_force_destroy}"

  lifecycle {
    prevent_destroy = "${var.s3_prevent_destroy}"
  }

  tags = "${merge(var.common_tags,
    map("Name", "${local.environment}-${var.s3_bucket_name}-S3")
    )}"
}