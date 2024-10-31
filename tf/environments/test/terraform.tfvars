aws_region                = "eu-west-3"
vpc_cidr                  = "10.0.0.0/16"
public_subnet_cidrs       = ["10.0.1.0/24", "10.0.2.0/24"]
private_app_subnet_cidrs  = ["10.0.11.0/24", "10.0.12.0/24"]
private_data_subnet_cidrs = ["10.0.21.0/24", "10.0.22.0/24"]
availability_zones        = ["eu-west-3a", "eu-west-3b"]
project_name    = "webservice"
eks_cluster_name = "webservice-cluster"

/*bastion_instance_type     = "t3.micro"
bastion_key_name          = "bastion_key"
bastion_allowed_ips       = ["0.0.0.0/0"]
bastion_public_keys       = ["/.ssh/bastion_key.pub"]
bastion_desired_capacity  = 2
bastion_min_size          = 2
bastion_max_size          = 2
*/

database_name              = "wordpress_db"
master_username            = "root" 
master_password             = "rootroot"
aurora_instance_count      = 2
aurora_instance_class      = "db.t3.medium"

cache_node_type = "cache.t3.micro"
cache_num_nodes = 1

environment     = "dev"
k8s_version     = "1.29"
kubeconfig_path = "~/.kube/config"
access_key      = "votre_access_key"
secret_key      = "votre_secret_key"

wordpress_image_repository = "my-wordpress"
wordpress_image_tag        = "latest"

tags = {
  Environment = "dev"
  Project     = "my-project"
}