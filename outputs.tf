output "arn" {
  value = aws_elasticsearch_domain.default.arn
}

output "endpoint" {
  value = aws_elasticsearch_domain.default.endpoint
}

output "kibana" {
  value = aws_elasticsearch_domain.default.kibana_endpoint
}

output "access_policy" {
  value = {
    arn  = aws_iam_policy.default.arn
    name = aws_iam_policy.default.name
  }
}
