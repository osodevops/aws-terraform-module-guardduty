# General

variable "account_id" {}

variable "aws_region" {}

variable "common_tags" {
  type = map
}

variable "environment" {
  type = string
  description = "The environment that the terraform has been applied to."
}

variable "guardduty_enabled" {
  type = bool
  default = true
}

# Kinesis

variable "kinesis_enabled" {
  type = bool
  default = false
}

variable "kinesis_firehose_arn" {
  description = "Set the arn for your kinesis firehose that is connected to elasticsearch"
  default = ""
}

variable "kinesis_log_group_name" {}

variable "kinesis_log_retention_in_days" {}

variable "kinesis_log_stream_name" {}

# Elasticsearch

variable "aws_es_s3_mode" {}

variable "aws_es_retry_duration" {}

variable "aws_es_index_period" {}

variable "aws_es_index_name" {}

variable "aws_elasticsearch_domain" {}

# SNS

variable "sns_topic_name" {
  type        = string
  description = "The name of the SNS topic to send AWS GuardDuty findings."
}

### S3 variables

variable "s3_enabled" {
  default = true
}

variable "s3_prefix" {
  description = "Set the prefix key for where objects are stored"
  default     = ""
}

variable "s3_bucket_acl" {
  default = "private"
}

variable "s3_bucket_force_destroy" {
  default = false
}

variable "s3_prevent_destroy" {
  default = true
}


variable "bucket_versioning" {
  type        = string
  description = "Set if the bucket objects should be versioned or not."
  default = "Suspended"
}

variable "s3_sse_algorithm" {
  description = "Set the server side encryption on the bucket, choose between AES or KMS"
  default = "AES256"
}

variable "mfa_delete_enabled" {
  type        = string
  description = "Require MFA to delete objects."
  default     = "Disabled"
}

variable "enable_lifecycle" {
  description = "Enable the object lifecycle and store older items in Glacier"
  default = true
}

variable "current_ia_transition_days" {
  default = 30
}

variable "current_glacier_transition_days" {
  default = 60
}

variable "noncurrent_ia_transition_days" {
  default = 30
}

variable "noncurrent_glacier_transition_days" {
  default = 60
}

variable "delete_expired_objects" {
  default = false
}

variable "current_version_expiration_days" {
  default = 90
}

variable "block_public_acls" {
  default = true
}

variable "block_public_policy" {
  default = true
}

variable "ignore_public_acls" {
  default = true
}

variable "restrict_public_buckets" {
  default = true
}

variable "intelligent_tiering_configuration_name" {
  type        = string
  description = "The name of the IT config name."
}

variable "deep_archive_access_days" {
  type    = number
  default = 180
}

variable "archieve_access_days" {
  type    = number
  default = 125
}