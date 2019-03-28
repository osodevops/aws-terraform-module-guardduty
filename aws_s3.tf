resource "aws_s3_bucket" "security" {
  bucket_prefix = "${var.bucket_prefix}"
  acl           = "private"
  region        = "${var.aws_region}"

  lifecycle {
    prevent_destroy = true
  }

  tags = "${merge(map("Name","Security Bucket"), var.tags)}"
}

