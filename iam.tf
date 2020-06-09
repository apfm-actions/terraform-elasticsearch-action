resource "aws_iam_policy" "default" {
  name   = "ApfmElasticSearch-${var.github_project}"
  policy = data.aws_iam_policy_document.default.json
}

data "aws_iam_policy_document" "default" {
  statement {
    effect    = "Allow"
    resources = [aws_elasticsearch_domain.default.arn ]
    actions   = ["es:*"]
  }

  statement {
    effect    = "Deny"
    resources = [aws_elasticsearch_domain.default.arn ]
    actions   = [
      "es: DeleteElasticsearchDomain",
      "es: CreateElasticsearchDomain"
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["${aws_elasticsearch_domain.default.arn}/*"]
    actions   = ["es:*"]
  }
}
