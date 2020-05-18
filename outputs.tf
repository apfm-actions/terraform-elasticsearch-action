output "es" {
    value = {
        arn = aws_elasticsearch_domain.es_domain.arn
        endpoint = aws_elasticsearch_domain.es_domain.endpoint
        kibana_endpoint = aws_elasticsearch_domain.es_domain.kibana_endpoint
    } 
}