resource "aws_s3_bucket" "security" {
  bucket_prefix = "${var.prefix}"
  acl           = "private"
  region        = "${var.region}"

  lifecycle {
    prevent_destroy = true
  }

  tags = "${merge(map("Name","Guardduty Findings Bucket"), var.tags)}"
}

