variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

/*variable "nlb_dns_name" {
  description = "DNS name of the Network Load Balancer"
  type        = string
}*/

variable "region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "eu-west-3"  # ou la région de votre choix
}

variable "lb_dns_name" {
  description = "DNS name of the Load Balancer for WordPress"
  type        = string
  default     = ""
}
variable "lb_exists" {
  description = "Whether the Load Balancer exists yet"
  type        = bool
  default     = false
}