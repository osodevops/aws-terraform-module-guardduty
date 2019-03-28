variable "sns_topic_name" {
  type        = "string"
  description = "The name of the SNS topic to send AWS GuardDuty findings."
}

variable "enabled" {
  default = true
}

variable "bucket" {}

variable "prefix" {
  default = ""
}