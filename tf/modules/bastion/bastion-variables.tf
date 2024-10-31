variable "ami_id" {
  description = "AMI ID for the Bastion host"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the Bastion host"
  type        = string
}

variable "key_name" {
  description = "Key name for SSH access"
  type        = string
}

variable "public_keys" {
  description = "List of public SSH keys"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the bastion hosts"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the Bastion host will be deployed"
  type        = string
}

variable "project_name" {
  description = "Project name tag"
  type        = string
}

variable "allowed_ips" {
  description = "List of IP addresses allowed to connect to the bastion"
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired number of bastion instances"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum number of bastion instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of bastion instances"
  type        = number
  default     = 1
}