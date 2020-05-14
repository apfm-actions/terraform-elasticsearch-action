resource "aws_elasticsearch_domain" "es_domain" {
  domain_name           = var.es_domain
  elasticsearch_version = var.es_version

  cluster_config {
    instance_type = var.es_instance_type
  }

  snapshot_options {
    automated_snapshot_start_hour = var.es_snapshot_hour
  }

ebs_options {
    ebs_enabled = var.es_ebs_enabled
    volume_type = (var.es_ebs_enabled == true ? var.es_volume_type : null)
    volume_size = (var.es_ebs_enabled == true ? var.es_volume_size : null)
}

  tags = {
    ES_Domain = var.es_domain
  }
}