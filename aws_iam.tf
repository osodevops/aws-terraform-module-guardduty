data "aws_iam_policy_document" "guardduty_s3" {
  statement {
    actions = [
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.guardduty_s3.id}",
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.guardduty_s3.id}/${var.s3_prefix}*",
    ]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

resource "aws_iam_policy" "guardduty_s3" {
  name_prefix = "guardduty-s3-"
  policy      = "${data.aws_iam_policy_document.guardduty_s3.json}"
  count       = "${var.enabled ? 1 : 0}"
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
  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_role.json}"
  count              = "${var.enabled ? 1 : 0}"
}

resource "aws_iam_role_policy_attachment" "guardduty_s3" {
  role       = "${aws_iam_role.guardduty_s3.name}"
  policy_arn = "${aws_iam_policy.guardduty_s3.arn}"
  count      = "${var.enabled ? 1 : 0}"
}