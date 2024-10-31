output "eks_cluster_name" {
  description = "Nom du cluster EKS"
  value       = module.eks.eks_cluster_name
}

output "eks_cluster_id" {
  description = "Identifiant du cluster EKS"
  value       = module.eks.eks_cluster_id
}

output "eks_cluster_version" {
  description = "Version du cluster EKS"
  value       = module.eks.eks_cluster_version
}

output "eks_cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = module.eks.eks_cluster_endpoint
}

output "kubeconfig_certificate_authority_data" {
  value = module.eks.kubeconfig_certificate_authority_data
}

output "eks_oidc_provider_url" {
  value = module.eks.eks_oidc_provider_url
}

output "eks_oidc_provider_arn" {
  value = module.eks.eks_oidc_provider_arn
}


/*output "nlb_dns_name" {
  description = "The DNS name of the NLB"
  value       = module.nlb.nlb_dns_name
}*/

output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = module.cloudfront.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = module.cloudfront.cloudfront_domain_name
}
output "ecr_repository_url" {
  description = "L'URL du repository ECR"
  value       = module.ecr.repository_url
}