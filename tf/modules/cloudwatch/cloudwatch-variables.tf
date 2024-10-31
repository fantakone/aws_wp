variable "project_name" {
  description = "Name of the project, used for naming resources"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain logs in CloudWatch"
  type        = number
  default     = 120
}

variable "log_metric_filter_name" {
  description = "Name of the CloudWatch log metric filter"
  type        = string
  default     = "error-metric"
}

variable "log_metric_filter_pattern" {
  description = "Pattern to match for the CloudWatch log metric filter"
  type        = string
  default     = "ERROR"
}

variable "metric_transformation_namespace" {
  description = "Namespace for the CloudWatch metric"
  type        = string
  default     = "MyApplication"
}

variable "metric_transformation_name" {
  description = "Name of the CloudWatch metric"
  type        = string
  default     = "ErrorCount"
}

variable "log_stream_name" {
  description = "Name of the CloudWatch log stream"
  type        = string
  default     = "stream1"
}
