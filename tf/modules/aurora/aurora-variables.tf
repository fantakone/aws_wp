variable "project_name" {
  type        = string
  description = "Nom du projet"
}

variable "private_data_subnet_ids" {
  type        = list(string)
  description = "Liste des IDs des subnets privés de données pour Aurora"
}

variable "availability_zones" {
  type        = list(string)
  description = "Liste des zones de disponibilité pour Aurora"
}

variable "database_name" {
  type        = string
  description = "Nom de la base de données Aurora"
}

variable "master_username" {
  type        = string
  description = "Nom d'utilisateur principal pour Aurora"
}

variable "master_password" {
  type        = string
  description = "Mot de passe principal pour Aurora"
}

variable "vpc_id" {
  type        = string
  description = "ID du VPC"
}

variable "private_app_subnet_cidrs" {
  type        = list(string)
  description = "Liste des CIDRs des subnets privés d'application"
}

variable "instance_count" {
  type        = number
  description = "Nombre d'instances Aurora à créer"
  default     = 1
}

variable "instance_class" {
  type        = string
  description = "Classe d'instance pour les instances Aurora"
  default     = "db.t3.small"
}