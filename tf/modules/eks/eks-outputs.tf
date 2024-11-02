output "eks_cluster_name" {
  value = aws_eks_cluster.eks-cluster.name
}

output "eks_cluster_id" {
  value = aws_eks_cluster.eks-cluster.id
}

output "eks_cluster_version" {
  value = aws_eks_cluster.eks-cluster.version
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks-cluster.endpoint
}

output "kubeconfig_certificate_authority_data" {
  value = aws_eks_cluster.eks-cluster.certificate_authority[0].data
}

output "eks_oidc_provider_url" {
  value = aws_iam_openid_connect_provider.eks-openid-connect.url
}

output "eks_oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks-openid-connect.arn
}

/*output "ebs_storage_class_name" {
  value = kubernetes_storage_class.ebs_sc.metadata[0].name
}*/