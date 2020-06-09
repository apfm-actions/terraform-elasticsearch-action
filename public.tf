data "aws_iam_policy_document" "public" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["es:*"]

    resources = [
      "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.github_project}/*"
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values = local.allowed_ips
    }
  }
}

data "aws_iam_policy_document" "vpc" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["es:*"]

    resources = [
      "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.github_project}/*"
    ]
  }
}
