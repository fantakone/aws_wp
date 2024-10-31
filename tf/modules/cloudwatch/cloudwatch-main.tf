# modules/cloudwatch/main.tf

module "log_metric_filter" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-metric-filter"
  version = "~> 3.0"

  log_group_name = module.log_group.cloudwatch_log_group_name

  name    = var.log_metric_filter_name
  pattern = var.log_metric_filter_pattern

  metric_transformation_namespace = var.metric_transformation_namespace
  metric_transformation_name      = var.metric_transformation_name
}

module "log_group" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
  version = "~> 3.0"

  name              = "${var.project_name}-log-group"
  retention_in_days = var.log_retention_days
}

module "log_stream" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-stream"
  version = "~> 3.0"

  name           = var.log_stream_name
  log_group_name = module.log_group.cloudwatch_log_group_name
}