provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_group" "group" {
  name = "${var.role_group_name}-group"
}

resource "aws_iam_policy" "policy" {
  name        = "${var.role_group_name}-group-membership-policy"
  description = "This policy will allow users to assume the role."
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_group_policy_attachment" "attach" {
  group      = aws_iam_group.group.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_role" "role" {
  name = var.role_group_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name = "${var.role_group_name}-role"
  }
}

resource "aws_iam_user" "user" {
  name = var.username
  tags = {
    Name = var.username
  }
}

resource "aws_iam_user_group_membership" "group_membership" {
  user = aws_iam_user.user.name
  groups = [
    aws_iam_group.group.name
  ]
}