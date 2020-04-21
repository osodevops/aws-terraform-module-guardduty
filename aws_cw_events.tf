resource "aws_cloudwatch_event_rule" "guardduty_event_rule" {
  name          = "guardduty-finding-events"
  description   = "AWS GuardDuty event findings"
  event_pattern = file("${path.module}/event-pattern.json")
}

resource "aws_cloudwatch_event_target" "sns_event_target" {
  rule      = aws_cloudwatch_event_rule.guardduty_event_rule.name
  target_id = "send-to-sns"
  arn       = aws_sns_topic.main.arn

  input_transformer {
    input_paths = {
      title = "$.detail.title"
    }

    input_template = "\"GuardDuty finding: <title>\""
  }
}

resource "aws_cloudwatch_event_target" "s3_target" {
  count     = var.s3_enabled ? 1 : 0
  target_id = "send-to-s3"
  arn       = aws_lambda_function.guardduty_s3[0].arn
  rule      = aws_cloudwatch_event_rule.guardduty_event_rule.name
}

resource "aws_cloudwatch_event_target" "kinesis_target" {
  count     = var.kinesis_enabled ? 1 : 0
  target_id = "send-to-es"
  arn       = aws_kinesis_firehose_delivery_stream.kinesis_delivery[0].arn
  rule      = aws_cloudwatch_event_rule.guardduty_event_rule.name
  role_arn  = aws_iam_role.kinesis_event_role[0].arn
}
