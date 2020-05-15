# Log Management

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_log_group" "es_log_group" {
  name = "${var.es_domain}-log_group"
}

resource "aws_cloudwatch_log_resource_policy" "es_log_resource_policy" {
  policy_name = "${var.es_domain}-es_log_resource_policy"

  policy_document = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
EOF
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
      "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.es_domain}/*"
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"

      values = split(",", var.es_source_ip)
    }
  }
}

# Cluster creation

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

  access_policies = data.aws_iam_policy_document.es_public_source.json

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.es_log_group.arn
    log_type                 = "INDEX_SLOW_LOGS"
  }

  tags = {
    es_domain  = var.es_domain
    project    = var.project_name
    owner      = var.project_owner
    email      = var.project_email
    created_by = "terraform-elasticsearch-action"
  }
}