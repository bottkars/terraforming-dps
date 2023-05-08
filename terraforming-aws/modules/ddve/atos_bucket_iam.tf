data "aws_iam_policy_document" "atos-bucket-policy" {
  statement {
    sid    = "AtosbucketPolicy"
    effect = "Allow"
    actions = ["s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
    "s3:DeleteObject"]
    resources = [
      aws_s3_bucket.atos-bucket.arn,
      "${aws_s3_bucket.atos-bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "atos-bucket" {
  name   = "${var.environment}-atos-bucket-policy-${var.ddve_instance}"
  policy = data.aws_iam_policy_document.atos-bucket-policy.json
  tags = merge(
    var.tags,
    {
      "environment" = var.environment
    },
  )
}

resource "aws_iam_role_policy_attachment" "atos-bucket" {
  role       = aws_iam_role.atos-bucket.name
  policy_arn = aws_iam_policy.atos-bucket.arn
}

resource "aws_iam_instance_profile" "atos-bucket" {
  name = "${var.environment}-atos-bucket-${var.ddve_instance}"
  role = aws_iam_role.atos-bucket.name

  lifecycle {
    ignore_changes  = [tags, tags_all, name]
  }
}


resource "aws_iam_role" "atos-bucket" {
  name = "${var.environment}-atos-bucket-${var.ddve_instance}"

  lifecycle {
    create_before_destroy = true
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": [
        "sts:AssumeRole"
      ]
    }
  ]
}
EOF
}


data "aws_iam_policy_document" "assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
