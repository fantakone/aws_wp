variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR block for the public subnet"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of Private Subnet CIDRs"
  type        = list(string)
  default     = [] 
}
variable "availability_zones" {
  description = "List of AZ"
  type        = list(string)
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "internet_gateway_id" {
  description = "IGW ID"
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
