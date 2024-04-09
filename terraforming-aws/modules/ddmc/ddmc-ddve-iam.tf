data "aws_iam_policy_document" "ddmc-iam-policy" {
  statement {
    sid    = "DDMCIAMpolicy"
    effect = "Allow"
    actions = [
      "iam:CreateRole",
      "iam:GetRole",
      "iam:DeleteRole",
      "iam:CreateInstanceProfile",
      "iam:DeleteInstanceProfile",
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:PassRole",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:GetRolePolicy",
      "ec2:RunInstances",
      "ec2:TerminateInstances",
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:ModifyVolumeAttribute",
      "ec2:DeleteVolume",
      "ec2:DescribeImages",
      "ec2:DescribeVolumes",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "cloudformation:CreateStack",
      "cloudformation:DeleteStack",
      "cloudformation:ValidateTemplate",
      "cloudformation:DescribeStackEvents",
      "cloudformation:DescribeStacks"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "ddmc-iam-policy" {
  name   = "${var.environment}-ddmc-iam-policy-${var.ddmc_instance}"
  policy = data.aws_iam_policy_document.ddmc-iam-policy.json
  tags = merge(
    var.tags,
    {
      "environment" = var.environment
    },
  )
}

resource "aws_iam_role_policy_attachment" "ddmc-iam-attachement" {
  role       = aws_iam_role.ddmc-iam-role.name
  policy_arn = aws_iam_policy.ddmc-iam-policy.arn
}

resource "aws_iam_instance_profile" "ddmc-iam-profile" {
  name = "${var.environment}-ddmc-iam-profile-${var.ddmc_instance}"
  role = aws_iam_role.ddmc-iam-role.name

  lifecycle {
    ignore_changes = [tags, tags_all, name]
  }
}


resource "aws_iam_role" "ddmc-iam-role" {
  name = "${var.environment}-ddmc-iam-role-${var.ddmc_instance}"

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
