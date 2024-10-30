variable "project_name" {
  type        = string
  description = "Nom du projet"
}

variable "vpc_id" {
  type        = string
  description = "ID du VPC"
}

variable "private_data_subnet_ids" {
  type        = list(string)
  description = "Liste des IDs des subnets privés de données pour ElastiCache"
}

variable "node_type" {
  type        = string
  description = "Type de nœud pour ElastiCache"
  default     = "cache.t3.micro"
}

variable "num_cache_nodes" {
  type        = number
  description = "Nombre de nœuds pour le cluster ElastiCache"
  default     = 1
}

variable "private_app_subnet_cidr" {
  type        = string
  description = "CIDR du subnet privé d'application"
}