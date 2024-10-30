variable "aws_region" {
  description = "AWS region"
  type        = string
}

/*variable "bastion_instance_type" {
  description = "Instance type for the Bastion host"
  type        = string
}

variable "bastion_key_name" {
  description = "Key name for SSH access"
  type        = string
}

variable "bastion_public_keys" {
  description = "List of public SSH keys for the bastion"
  type        = list(string)
}*/

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for private application subnets"
  type        = list(string)
}

variable "private_data_subnet_cidrs" {
  description = "CIDR blocks for private data subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "project_name" {
  description = "Project name tag"
  type        = string
}

/*variable "bastion_desired_capacity" {
  description = "Desired number of bastion instances"
  type        = number
  default     = 1
}

variable "bastion_min_size" {
  description = "Minimum number of bastion instances"
  type        = number
  default     = 1
}

variable "bastion_max_size" {
  description = "Maximum number of bastion instances"
  type        = number
  default     = 1
}

variable "bastion_allowed_ips" {
  description = "List of IP addresses allowed to connect to the bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}*/

variable "database_name" {
  type        = string
  description = "The name of the database to create when the Aurora cluster is created"
}

variable "master_username" {
  type        = string
  description = "Username for the master DB user"
}

variable "master_password" {
  type        = string
  description = "Password for the master DB user. Note: This should be handled securely and not stored in plain text"
  sensitive   = true
}

variable "aurora_instance_count" {
  type        = number
  description = "The number of instances to create in the Aurora cluster"
}

variable "aurora_instance_class" {
  type        = string
  description = "The instance class to use for the Aurora cluster instances (e.g., db.t3.medium)"
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = []
}

variable "cache_node_type" {
  type        = string
  description = "Type de nœud pour ElastiCache"
  default     = "cache.t3.micro"
}

variable "cache_num_nodes" {
  type        = number
  description = "Nombre de nœuds pour le cluster ElastiCache"
  default     = 1
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "k8s_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "kubeconfig_path" {
  description = "Path to save the kubeconfig file"
  type        = string
}

variable "access_key" {
  description = "AWS access key"
  type        = string
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
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

variable "exclude_aurora" {
    type        = bool
    description = "Exclure aurora des commandes"
    default     = false
}

variable "wordpress_image_repository" {
  default = "my-wordpress"
}

variable "wordpress_image_tag" {
  default = "latest"
}

variable "lb_dns_name" {
  description = "DNS name of the Load Balancer for WordPress"
  type        = string
  default     = "default-lb-name.not-real.com"
}