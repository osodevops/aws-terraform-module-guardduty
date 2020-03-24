variable "sns_topic_name" {
  type        = string
  description = "The name of the SNS topic to send AWS GuardDuty findings."
}

variable "s3_enabled" {
  default = false
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

variable "s3_bucket_policy" {
}

variable "kinesis_enabled" {
  default = false
}

variable "kinesis_firehose_arn" {
  description = "Set the arn for your kinesis firehose that is connected to elasticsearch"
  default     = ""
}

variable "common_tags" {
  type = map(string)
}

locals {
  environment = substr(var.common_tags["Environment"], 0, 1)
}

