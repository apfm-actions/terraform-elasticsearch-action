variable "es_domain" {
  type        = string
  description = "AWS Elasticsearch service domain"
}

variable "es_version" {
  type        = string
  default     = "7.4"
  description = "Elasticsearch version number"
}

variable "es_instance_type" {
  type        = string
  default     = "t2.medium"
  description = "AWS Instance Type to deploy the cluster"
}

variable "es_snapshot_hour" {
  type        = number 
  default     = 23
  description = "Hour during which the service takes an automated daily snapshot of the indices in the domain. UTC Time"
}