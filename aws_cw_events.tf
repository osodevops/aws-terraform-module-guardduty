resource "aws_cloudwatch_event_rule" "main" {
  name          = "guardduty-finding-events"
  description   = "AWS GuardDuty event findings"
  event_pattern = "${file("${path.module}/event-pattern.json")}"
}

resource "aws_cloudwatch_event_target" "main" {
  rule      = "${aws_cloudwatch_event_rule.main.name}"
  target_id = "send-to-sns"
  arn       = "${data.aws_sns_topic.main.arn}"

  input_transformer = {
    input_paths {
      title = "$.detail.title"
    }

    input_template = "\"GuardDuty finding: <title>\""
  }
}