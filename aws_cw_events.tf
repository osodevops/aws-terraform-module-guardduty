resource "aws_cloudwatch_event_rule" "gd_rule" {
  name          = "guardduty-finding-events"
  description   = "AWS GuardDuty event findings"
  event_pattern = "${file("${path.module}/event-pattern.json")}"
}

resource "aws_cloudwatch_event_target" "sns_target" {
  rule      = "${aws_cloudwatch_event_rule.gd_rule.name}"
  target_id = "send-to-sns"
  arn       = "${aws_sns_topic.main.arn}"

  input_transformer = {
    input_paths {
      title = "$.detail.title"
    }

    input_template = "\"GuardDuty finding: <title>\""
  }
}


resource "aws_cloudwatch_event_target" "s3_target" {
  rule  = "${aws_cloudwatch_event_rule.gd_rule.name}"
  target_id = "send-to-s3"
  arn   = "${aws_lambda_function.guardduty_s3.arn}"
  count = "${var.enabled ? 1 : 0}"
}