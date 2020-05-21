output "arn" {
  value = aws_elasticsearch_domain.default.arn
}

output "endpoint" {
  value = aws_elasticsearch_domain.default.endpoint
}

output "kibana" {
  value = var.kibana ? aws_elasticsearch_domain.default.kibana_endpoint : ""
}
