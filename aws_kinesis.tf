resource "aws_kinesis_firehose_delivery_stream" "kinesis_delivery" {
  count       = var.kinesis_enabled ? 1 : 0
  name        = "terraform-kinesis-firehose-test-stream"
  destination = "elasticsearch"

  s3_configuration {
    role_arn           = aws_iam_role.kinesis_delivery_role[0].arn
    bucket_arn         = aws_s3_bucket.kinesis_bucket[0].arn
    buffer_size        = 50
    buffer_interval    = 60
    compression_format = "UNCOMPRESSED"

    cloudwatch_logging_options {
      enabled         = "true"
      log_group_name  = aws_cloudwatch_log_group.kinesis_log_group.name
      log_stream_name = aws_cloudwatch_log_stream.kinesis_log_stream.name
    }
  }

  elasticsearch_configuration {
    buffering_interval    = 60
    buffering_size        = 50 
    domain_arn            = "arn:aws:es:${var.aws_region}:${var.account_id}:domain/${var.aws_elasticsearch_domain}"
    role_arn              = aws_iam_role.kinesis_delivery_role[0].arn
    index_name            = var.aws_es_index_name
    index_rotation_period = var.aws_es_index_period
    type_name             = "log"
    retry_duration        = var.aws_es_retry_duration
    s3_backup_mode        = var.aws_es_s3_mode
  }
}