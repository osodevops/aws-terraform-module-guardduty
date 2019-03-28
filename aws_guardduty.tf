resource "aws_guardduty_detector" "guardduty" {
  enable = true
}

resource "aws_guardduty_ipset" "IPSet" {
  activate    = true
  detector_id = "${aws_guardduty_detector.guardduty.id}"
  format      = "TXT"
  location    = "s3://${aws_s3_bucket_object.ip_list.bucket}/${aws_s3_bucket_object.ip_list.key}"
  name        = "example_ipset"
}