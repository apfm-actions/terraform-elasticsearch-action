# Log Management

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_vpc" "selected" {
  id = var.network_vpc_id
}

resource "aws_cloudwatch_log_group" "es_log_group" {
  name = "${var.project_name}-log_group"
  tags = local.common_tags
}

# Log policy

data "aws_iam_policy_document" "es_log_resource_policy" {
  statement {

    principals {
      type        = "Service"
      identifiers = ["es.amazonaws.com"]
    }

    actions = [
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
      "logs:CreateLogStream"
    ]

    resources = [
      "arn:aws:logs:*"
    ]
  }
}

resource "aws_cloudwatch_log_resource_policy" "es_log_resource_policy" {
  policy_name = "${var.project_name}-es_log_resource_policy"

  policy_document = data.aws_iam_policy_document.es_log_resource_policy.json
}

# IAM Policy creation (sourceIP)
data "aws_iam_policy_document" "es_public_source" {
  statement {

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "es:*"
    ]

    resources = [
      "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.project_name}/*"
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"

      values = split(",", var.es_source_ip)
    }
  }
}

# IAM Policy creation (VPC)
data "aws_iam_policy_document" "es_vpc_source" {
  statement {

    principals {
      type        = "AWS"
      identifiers = split(",", var.es_source_role)
    }
    actions = [
      "es:*"
    ]

    resources = [
      "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.project_name}/*"
    ]
  }
}

resource "aws_security_group" "es_security_group" {
  name        = "${var.network_vpc_id}-elasticsearch-${var.project_name}"
  description = "Managed by terraform-elasticsearch-action"
  vpc_id      = var.network_vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    #cidr_blocks = data.aws_vpc.selected.cidr_block
    cidr_blocks = (var.es_source_ip != null ? [data.aws_vpc.selected.cidr_block] : concat([data.aws_vpc.selected.cidr_block], split(",", var.es_source_ip)))
  }

  tags = local.common_tags
}

# Cluster creation

resource "aws_elasticsearch_domain" "es_domain" {
  domain_name           = var.project_name
  elasticsearch_version = var.es_version

  cluster_config {
    instance_type  = var.es_instance_type
    instance_count = var.es_instance_count

    zone_awareness_enabled = (var.es_instance_count < 2 ? false : true)

    zone_awareness_config {
      availability_zone_count = (var.es_instance_count < 3 ? (var.es_instance_count == 2 ? 2 : null ) : 3)
    }
  }

  snapshot_options {
    automated_snapshot_start_hour = var.es_snapshot_hour
  }

  vpc_options {

    subnet_ids = (var.es_vpc == true && var.es_instance_count >= 3 ? split(",", var.network_private_subnets) : (
      var.es_vpc == true ? [element(split(",", var.network_private_subnets), 0)] : null
    ))
    #subnet_ids = [(var.es_vpc == true ? element(split(",", var.network_private_subnets), 0) : null)]

    security_group_ids = (var.es_vpc == true ? [aws_security_group.es_security_group.id] : null)
  }

  ebs_options {
    ebs_enabled = var.es_ebs_enabled
    volume_type = (var.es_ebs_enabled == true ? var.es_volume_type : null)
    volume_size = (var.es_ebs_enabled == true ? var.es_volume_size : null)
  }

  #access_policies = (var.es_vpc == true ? data.aws_iam_policy_document.es_vpc_source.json : data.aws_iam_policy_document.es_public_source.json)

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.es_log_group.arn
    log_type                 = "INDEX_SLOW_LOGS"
  }

  tags = local.common_tags
}

locals {
  common_tags = {
    app : var.app,
    env : terraform.workspace,
    budget : var.budget,
    repo : var.repo,
    es_domain : var.project_name,
    project : var.project_name,
    owner : var.project_owner,
    email : var.project_email,
    created_by : "terraform-elasticsearch-action"
  }
}