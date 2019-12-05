resource "aws_kinesis_firehose_delivery_stream" "kinesis_delivery" {
  name        = "terraform-kinesis-firehose-test-stream"
  destination = "elasticsearch"

  s3_configuration {
    role_arn           = aws_iam_role.kinesis_delivery_role.arn
    bucket_arn         = aws_s3_bucket.kinesis_bucket.arn
    buffer_size        = 60
    buffer_interval    = 50
    compression_format = "UNCOMPRESSED"

    cloudwatch_logging_options {
      enabled = "true"
      log_group_name = "deliverystream"
      log_stream_name = "s3Backup"
    }
  }

  elasticsearch_configuration {
    buffering_interval    = 60
    buffering_size        = 50 
    domain_arn            = var.aws_elasticsearch_domain
    role_arn              = aws_iam_role.kinesis_delivery_role.arn
    index_name            = var.aws_es_index_name
    index_rotation_period = var.aws_es_index_period
    type_name             = "log"
    retry_duration        = var.aws_es_retry_duration
    s3_backup_mode        = var.aws_es_s3_mode

    processing_configuration {
      enabled = "true"

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${aws_lambda_function.lambda_processor.arn}:$LATEST"
        }
      }
    }
  }
}