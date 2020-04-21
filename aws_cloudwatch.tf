resource "aws_cloudwatch_log_group" "kinesis_log_group" {
  name              = var.kinesis_log_group_name
  retention_in_days = var.kinesis_log_retention_in_days
}

resource "aws_cloudwatch_log_stream" "kinesis_log_stream" {
  name           = var.kinesis_log_stream_name
  log_group_name = aws_cloudwatch_log_group.kinesis_log_group.name
}