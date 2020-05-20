data "aws_iam_policy_document" "allowed_ips" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["es:*"]

    resources = [
      "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.es_domain}/*"
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values = split(",", var.allowed_ips)
    }
  }
}
