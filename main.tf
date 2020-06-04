# Log Management
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_vpc" "selected" {
  id = var.network_vpc_id
}

data "aws_subnet" "selected" {
  count = length(split(",", var.subnet_id_private))
  id    = element(split(",", var.subnet_id_private), count.index)
}

locals {
  subnet_ids  = element(chunklist(data.aws_subnet.selected[*].id, min(var.instance_count, 3)), 0)
  allowed_ips = var.allowed_ips != "" ? split(",", var.allowed_ips) : []
  tags = {
    app : var.github_project,
    env : terraform.workspace,
    repo : var.github_repository
    project : var.project_name,
    owner : var.project_owner,
    email : var.project_email,
    created_by : "terraform-elasticsearch-action"
  }
}

# Cluster creation
resource "aws_elasticsearch_domain" "default" {
  domain_name           = var.project_name
  elasticsearch_version = var.engine_version

  access_policies = var.public ? data.aws_iam_policy_document.allowed_ips.json : null

  cluster_config {
    instance_type  = var.instance_type
    instance_count = var.instance_count

    zone_awareness_enabled = (var.instance_count < 2 ? false : true)
    zone_awareness_config {
      availability_zone_count = (var.instance_count < 3 ? (var.instance_count == 2 ? 2 : null ) : 3)
    }
  }

  snapshot_options {
    automated_snapshot_start_hour = var.snapshot_hour
  }

  vpc_options {
    subnet_ids         = var.public ? null : local.subnet_ids
    security_group_ids = var.public ? null : [aws_security_group.default.id]
  }

  ebs_options {
    ebs_enabled = var.ebs
    volume_type = var.ebs ? var.volume_type : null
    volume_size = var.ebs ? var.volume_size : null
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.default.arn
    log_type                 = "INDEX_SLOW_LOGS"
  }

  tags = local.tags

  depends_on = [aws_cloudwatch_log_resource_policy.logging]
}

resource "aws_security_group" "default" {
  name        = "${var.project_name}-elasticsearch"
  description = "Managed by terraform-elasticsearch-action"
  vpc_id      = var.network_vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = compact(concat(data.aws_subnet.selected[*].cidr_block, local.allowed_ips))
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = compact(concat(data.aws_subnet.selected[*].cidr_block, local.allowed_ips))
  }

  tags = local.tags
}
