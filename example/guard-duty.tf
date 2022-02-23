module "s3" {
  source                        = "../"
  account_id                    = var.account_id
  environment                   = var.environment
  aws_region                    = "eu-west-2"
  s3_enabled                    = true
  s3_prefix                     = "${var.environment}-"
  s3_bucket_acl                 = "aws:kms"
  s3_bucket_force_destroy       = false
  s3_prevent_destroy            = true
  kinesis_enabled               = false
  kinesis_firehose_arn          = ""
  kinesis_log_retention_in_days = 0
  aws_es_retry_duration         = 0
  aws_es_index_name             = ""
  sns_topic_name                = ""
  aws_es_s3_mode                = ""
  aws_es_index_period           = ""

  kinesis_log_stream_name       = var.kinesis_log_stream_name
  aws_elasticsearch_domain      = ""
  kinesis_log_group_name        = var.kinesis_log_group_name

  intelligent_tiering_configuration_name = var.intelligent_tiering_configuration_name
  
  common_tags=                  var.common_tags
}