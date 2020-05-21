locals {
  allowed_ips = var.allowed_ips != "" ? split(var.allowed_ips) : []
}
data "aws_iam_policy_document" "allowed_ips" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["es:*"]

    resources = [
      "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.project_name}/*"
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values = local.allowed_ips
    }
  }
}
