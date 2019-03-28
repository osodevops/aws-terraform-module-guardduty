data "aws_sns_topic" "main" {
  name = "${var.sns_topic_name}"
}