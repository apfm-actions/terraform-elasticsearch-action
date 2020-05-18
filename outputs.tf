output "es_arn" {
    description = "Elasticsearch service ARN"
    value = aws_elasticsearch_domain.es_domain.arn
}

output "es_endpoint" {
    description = "Elasticsearch service endpoint"
    value = aws_elasticsearch_domain.es_domain.endpoint
}

output "es_kibana_endpoint" {
    description = "Elasticsearch service endpoint"
    value = aws_elasticsearch_domain.es_domain.kibana_endpoint
}