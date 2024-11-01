provider "aws" {
  region = var.aws_region
  
}

/*data "aws_ami" "bastion" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}*/

/*data "aws_secretsmanager_secret" "bastion_public_key" {
  name = "bastion/ssh-public-key"
}*/

/*data "aws_secretsmanager_secret_version" "bastion_public_key" {
  secret_id = data.aws_secretsmanager_secret.bastion_public_key.id
}*/

module "vpc" {
  source       = "../../modules/vpc"
  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
}

module "subnets" {
  source                   = "../../modules/subnets"
  vpc_id                   = module.vpc.vpc_id
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_data_subnet_cidrs = var.private_data_subnet_cidrs
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_subnet_cidrs     = concat(var.private_app_subnet_cidrs, var.private_data_subnet_cidrs)
  availability_zones       = var.availability_zones
  project_name             = var.project_name
  internet_gateway_id      = module.vpc.internet_gateway_id

    depends_on = [module.vpc]
}

/*module "bastion" {
  source           = "../../modules/bastion"
  ami_id           = data.aws_ami.bastion.id
  instance_type    = var.bastion_instance_type
  key_name         = var.bastion_key_name
  public_keys      = var.bastion_public_keys
  subnet_ids       = module.subnets.public_subnet_ids
  vpc_id           = module.vpc.vpc_id
  allowed_ips      = var.bastion_allowed_ips
  project_name     = var.project_name
  desired_capacity = var.bastion_desired_capacity
  min_size         = var.bastion_min_size
  max_size         = var.bastion_max_size
}*/

terraform {
  backend "s3" {
    bucket = "s3-backend-webservice"
    key    = "terraform.tfstate"
    region = "eu-west-3"
    encrypt = true
  }
}

module "aurora" {
  source                   = "../../modules/aurora"
  project_name             = var.project_name
  vpc_id                   = module.vpc.vpc_id
  private_data_subnet_ids  = module.subnets.private_data_subnet_ids
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  availability_zones       = var.availability_zones
  database_name            = var.database_name
  master_username          = var.master_username
  master_password          = var.master_password
  instance_count           = var.aurora_instance_count
  instance_class           = var.aurora_instance_class

  depends_on = [module.subnets]
}
module "cache" {
  source                  = "../../modules/cache"
  project_name            = var.project_name
  vpc_id                  = module.vpc.vpc_id
  private_data_subnet_ids = module.subnets.private_data_subnet_ids
  private_app_subnet_cidr = var.private_app_subnet_cidrs[0]
  node_type               = var.cache_node_type
  num_cache_nodes         = var.cache_num_nodes

  depends_on = [module.subnets]
}

# création du cluster EKS
module "eks" {
  source                    = "../../modules/eks"
  environment               = var.environment
  eks_cluster_name = var.eks_cluster_name
  project_name     = var.project_name
  k8s_version               = var.k8s_version
  eks_node_groups_subnet_ids = module.subnets.private_app_subnet_id
  control_plane_subnet_ids  = concat(module.subnets.public_subnet_ids, module.subnets.private_app_subnet_id)
  tags                      = var.tags
  kubeconfig_path           = var.kubeconfig_path
  access_key                = var.access_key
  secret_key                = var.secret_key
  aws_region                = var.aws_region

  depends_on = [module.subnets]
}

# Configuration pour autoscaler
module "autoscaler" {
  source                = "../../modules/autoscaler"
  eks_cluster_name      = "${var.eks_cluster_name}"
  eks_oidc_provider_arn = module.eks.eks_oidc_provider_arn
  tags                  = var.tags
  depends_on            = [module.eks]
}

terraform {
  required_version = ">=1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }

  null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
  }
}

resource "local_file" "kubeconfig" {
  content = templatefile("${path.module}/kubeconfig.tpl", {
    cluster_name     = module.eks.eks_cluster_name
    cluster_endpoint = module.eks.eks_cluster_endpoint
    cluster_ca       = module.eks.kubeconfig_certificate_authority_data
  })
  filename = pathexpand("~/.kube/config")
 
}


module "cloudwatch" {
  source = "../../modules/cloudwatch"

  project_name                    = var.project_name
  log_retention_days              = var.log_retention_days
  log_metric_filter_name          = var.log_metric_filter_name
  log_metric_filter_pattern       = var.log_metric_filter_pattern
  metric_transformation_namespace = var.metric_transformation_namespace
  metric_transformation_name      = var.metric_transformation_name
  log_stream_name                 = var.log_stream_name

  depends_on            = [module.eks]
}

/*module "nlb" {
  source            = "../../modules/nlb"
  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.subnets.public_subnet_ids
}*/

module "cloudfront" {
  source       = "../../modules/cloudfront"
  project_name = var.project_name
  region       = var.aws_region
  lb_dns_name = "wordpress-lb.${var.aws_region}.elb.amazonaws.com"
  tags         = var.tags

  depends_on            = [module.eks]
}


module "ecr" {
  source       = "../../modules/ecr"
  project_name = var.project_name

}