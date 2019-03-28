# aws-terraform-module-guardduty

This module writes [AWS GuardDuty](https://aws.amazon.com/guardduty/) findings to an AWS S3 bucket of your choice.
There will be one file per finding.

Usage:

```hcl
provider "aws" {
  region = "eu-west-1"
}

resource "aws_guardduty_detector" "detector" {
  enable = true
}

resource "aws_s3_bucket" "bucket" {
  bucket = "example"
}

module "guardduty_s3" {
  source  = ""
  bucket  = "${aws_s3_bucket.bucket.id}"
  prefix  = ""
  enabled = true
}
```

```

Result:

```
$ aws s3 ls s3://example --recursive
