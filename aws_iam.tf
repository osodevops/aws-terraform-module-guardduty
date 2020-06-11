resource "aws_iam_policy" "guardduty_s3" {
  name_prefix = "guardduty-s3-"
  count       = var.s3_enabled ? 1 : 0
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Action": "s3:GetBucketLocation",
            "Resource": "${aws_s3_bucket.guardduty_s3[0].arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.guardduty_s3[0].arn}/${var.s3_prefix}*"
        },
        {
            "Sid": "AWSCreateLogs2020",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        }
    ]
}
EOF
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "guardduty_s3" {
  name               = "guardduty-s3"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
  count              = var.s3_enabled ? 1 : 0
}

resource "aws_iam_role_policy_attachment" "guardduty_s3" {
  role       = aws_iam_role.guardduty_s3[0].name
  policy_arn = aws_iam_policy.guardduty_s3[0].arn
  count      = var.s3_enabled ? 1 : 0
}

# Kinesis event iam 

data "aws_iam_policy_document" "kinesis_event_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [
        "events.amazonaws.com"
        ]
    }
  }
}

resource "aws_iam_role" "kinesis_event_role" {
  name = "guardduty-kinesis-event-role"
  assume_role_policy = data.aws_iam_policy_document.kinesis_event_role.json
  count = var.kinesis_enabled ? 1 : 0
}

data "aws_iam_policy_document" "kinesis_event_policy_doc" {
  statement {
    effect = "Allow"

    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch",
    ]

    resources = [
      aws_kinesis_firehose_delivery_stream.kinesis_delivery[0].arn
    ]
  }
}

resource "aws_iam_policy" "kinesis_event_policy" {
  name_prefix = "guardduty-kinesis-event-"
  policy = data.aws_iam_policy_document.kinesis_event_policy_doc.json
  count = var.kinesis_enabled ? 1 : 0
}

resource "aws_iam_role_policy_attachment" "kinesis_event_attachement" {
  role = aws_iam_role.kinesis_event_role[0].name
  policy_arn = aws_iam_policy.kinesis_event_policy[0].arn
  count = var.kinesis_enabled ? 1 : 0
}

# Kinesis delivery iam

data "aws_iam_policy_document" "kinesis_delivery_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [
        "firehose.amazonaws.com"
        ]
    }
  }
}

resource "aws_iam_role" "kinesis_delivery_role" {
  name = "guardduty-kinesis-delivery-role"
  assume_role_policy = data.aws_iam_policy_document.kinesis_delivery_role.json
  count = var.kinesis_enabled ? 1 : 0
}

resource "aws_iam_policy" "kinesis_delivery_policy" {
  name_prefix = "guardduty-kinesis-delivery-"
  count = var.kinesis_enabled ? 1 : 0
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:ListBucketMultipartUploads",
                "s3:ListBucket",
                "s3:GetObject",
                "s3:GetBucketLocation",
                "s3:AbortMultipartUpload"
            ],
            "Resource": [
                "${aws_s3_bucket.guardduty_s3[0].arn}/*",
                "${aws_s3_bucket.guardduty_s3[0].arn}"
            ]
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction",
                "lambda:GetFunctionConfiguration"
            ],
            "Resource": "arn:aws:lambda:${var.aws_region}:${var.account_id}:function:%FIREHOSE_DEFAULT_FUNCTION%:%FIREHOSE_DEFAULT_VERSION%"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "es:ESHttpPut",
                "es:ESHttpPost",
                "es:DescribeElasticsearchDomains",
                "es:DescribeElasticsearchDomainConfig",
                "es:DescribeElasticsearchDomain"
            ],
            "Resource": [
                "arn:aws:es:${var.aws_region}:${var.account_id}:domain/${var.aws_elasticsearch_domain}",
                "arn:aws:es:${var.aws_region}:${var.account_id}:domain/${var.aws_elasticsearch_domain}/*"
            ]
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "es:ESHttpGet",
            "Resource": [
                "arn:aws:es:${var.aws_region}:${var.account_id}:domain/${var.aws_elasticsearch_domain}/_all/_settings",
                "arn:aws:es:${var.aws_region}:${var.account_id}:domain/${var.aws_elasticsearch_domain}/_cluster/stats",
                "arn:aws:es:${var.aws_region}:${var.account_id}:domain/${var.aws_elasticsearch_domain}/${var.aws_es_index_name}*/_mapping/log",
                "arn:aws:es:${var.aws_region}:${var.account_id}:domain/${var.aws_elasticsearch_domain}/_nodes",
                "arn:aws:es:${var.aws_region}:${var.account_id}:domain/${var.aws_elasticsearch_domain}/_nodes/stats",
                "arn:aws:es:${var.aws_region}:${var.account_id}:domain/${var.aws_elasticsearch_domain}/_nodes/*/stats",
                "arn:aws:es:${var.aws_region}:${var.account_id}:domain/${var.aws_elasticsearch_domain}/_stats",
                "arn:aws:es:${var.aws_region}:${var.account_id}:domain/${var.aws_elasticsearch_domain}/${var.aws_es_index_name}*/_stats"
            ]
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "log:PutLogEvents",
            "Resource": "arn:aws:logs:${var.aws_region}:${var.account_id}:log-group:/aws/kinesisfirehose/${var.aws_elasticsearch_domain}:log-stream:*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "kinesis_delivery_attachement" {
  role = aws_iam_role.kinesis_delivery_role[0].name
  policy_arn = aws_iam_policy.kinesis_delivery_policy[0].arn
  count = var.kinesis_enabled ? 1 : 0
}