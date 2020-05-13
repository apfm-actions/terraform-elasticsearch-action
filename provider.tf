/* vim: ts=2:sw=2:sts=0:expandtab */

##
# We default to not running in 'deploy' mode.  This can be overwritten on
# the CLI. E.g. terraform apply -var=deploy=true
variable "deploy" {
  default = false
}

# Provider for apfm-dev, apfm-qa, apfm-stage, apfm-prod
provider "aws" {
  version = "~> 2.40"
  region = "${var.region}"

  assume_role {
    role_arn     = "arn:aws:iam::${var.account_root_id}:role/${var.role_name}"
    session_name = "${var.session_name}"
    external_id  = "${var.external_id}"
  }
}