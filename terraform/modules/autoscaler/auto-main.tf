module "autoscaler_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  # Tous les autres arguments restent les mêmes
  role_name                        = "${var.eks_cluster_name}-cluster-autoscaler-role"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_names = [var.eks_cluster_name]

  oidc_providers = {
    main = {
      provider_arn               = var.eks_oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }

  tags = var.tags

  # Ajout de l'override pour le rôle IAM
  create_role = false
}

# Création manuelle du rôle IAM avec le lifecycle
resource "aws_iam_role" "autoscaler" {
  name = "${var.eks_cluster_name}-cluster-autoscaler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = var.eks_oidc_provider_arn
        }
        Condition = {
          StringEquals = {
            "${replace(var.eks_oidc_provider_arn, "/^(.*provider/)/", "")}:sub" : "system:serviceaccount:kube-system:cluster-autoscaler"
          }
        }
      }
    ]
  })

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

# Attachement des politiques nécessaires
resource "aws_iam_role_policy_attachment" "autoscaler" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = aws_iam_role.autoscaler.name
}