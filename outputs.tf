output "arn" {
  value = aws_elasticsearch_domain.es_domain.arn
}

output "endpoint" {
  value = aws_elasticsearch_domain.es_domain.endpoint
}

output "kibana" {
  value = var.kibana ? aws_elasticsearch_domain.es_domain.kibana_endpoint : ""
}
