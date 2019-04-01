
data "archive_file" "source" {
  type        = "zip"
  source_file = "${path.module}/guardduty_s3.py"
  output_path = "${path.module}/guardduty_s3.py.zip"
}

resource "aws_lambda_function" "guardduty_s3" {
  filename         = "${path.module}/guardduty_s3.py.zip"
  source_code_hash = "${data.archive_file.source.output_base64sha256}"
  function_name    = "guardduty_s3"
  description      = "Write GuardDuty events to S3"
  runtime          = "python3.6"
  role             = "${aws_iam_role.guardduty_s3.arn}"
  handler          = "guardduty_s3.lambda_handler"
  timeout          = 10
  count            = "${var.enabled ? 1 : 0}"

  environment {
    variables = {
      bucket = "${aws_s3_bucket.guardduty_s3.id}"
      prefix = "${var.prefix}"
    }
  }

  lifecycle {
    # These will change even if the archive hashsum is the same.
    ignore_changes = ["filename", "last_modified"]
  }
}

resource "aws_lambda_permission" "guardduty_s3" {
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  function_name = "${aws_lambda_function.guardduty_s3.function_name}"
  source_arn    = "${aws_cloudwatch_event_rule.guardduty_finding.arn}"
  count         = "${var.enabled ? 1 : 0}"
}