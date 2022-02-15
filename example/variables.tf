variable "common_tags" {
  type = map
  default  = {
    Environment                         = "STAGING"
    CostCode                            = "S3"
    TF_State                            = "s3_bucket"
    Tool                                = "Terraform"
  }
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

variable "kinesis_log_group_name" {
  default = "kinesis_log"
}

variable "kinesis_log_retention_in_days" {
  default = 0
}

variable "kinesis_log_stream_name" {
  default = "kinesis_log_stream"
}

# Elasticsearch

variable "aws_es_s3_mode" {
  default = ""
}

variable "aws_es_retry_duration" {
  default = ""
}

variable "aws_es_index_period" {
  default = ""
}

variable "aws_es_index_name" {
  default = ""
}

variable "aws_elasticsearch_domain" {
  default = ""
}

# SNS

variable "sns_topic_name" {
  type        = string
  description = "The name of the SNS topic to send AWS GuardDuty findings."
  default = ""
}

### S3 variables

variable "s3_enabled" {
  default = true
}

variable "s3_bucket_name" {
  description = "Set the name for the S3 bucket"
  default     = "guardduty-findings-bucket"
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
  description = "Set if the bucket objects should be versioned or not"
  default = false
}

variable "s3_sse_algorithm" {
  description = "Set the server side encryption on the bucket, choose between AES or KMS"
  default = "AES256"
}

variable "mfa_delete_enabled" {
  description = "Require MFA to delete objects"
  default = false
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
  default = false
}

variable "block_public_policy" {
  default = false
}

variable "ignore_public_acls" {
  default = false
}

variable "restrict_public_buckets" {
  default = false
}


variable "account_id" {
  type = string
  description = "The account id of the account."
}