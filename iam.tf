resource "aws_iam_policy" "default" {
  name   = "ApfmElasticSearch-${var.project_name}"
  policy = data.aws_iam_policy_document.default.json
}

data "aws_iam_policy_document" "default" {
  statement {
    effect    = "Allow"
    resources = [aws_elasticsearch_domain.default.arn]
    actions   = [
      "es:ESHttpHead",
      "es:DescribeElasticsearchDomain",
      "es:ESHttpPost",
      "es:ESHttpGet",
      "es:ESHttpPatch",
      "es:ListTags",
      "es:ESHttpDelete",
      "es:ESHttpPut"
    ]
  }
}
