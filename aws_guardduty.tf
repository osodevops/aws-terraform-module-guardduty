resource "aws_guardduty_detector" "guardduty" {
  enable = var.guardduty_enabled
}