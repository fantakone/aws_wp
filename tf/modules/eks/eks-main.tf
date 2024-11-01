# création du Role IAM de cluster Amazon EKs
# source : https://docs.aws.amazon.com/fr_fr/eks/latest/userguide/service_IAM_role.html
resource "aws_iam_role" "EKSClusterRole" {
  name = "EKSClusterRole-${var.project_name}-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
  tags = var.tags
}


# This policy provides Kubernetes the permissions it requires to manage resources on your behalf.
# Kubernetes requires Ec2:CreateTags permissions to place identifying information on EC2 resources including but not limited to Instances, Security Groups, and Elastic Network Interfaces.
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.EKSClusterRole.name
}


# création du cluster EKS
resource "aws_eks_cluster" "eks-cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.EKSClusterRole.arn
  version  = var.k8s_version

  vpc_config {
    subnet_ids = var.control_plane_subnet_ids
  }

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy
  ]
}

# création du role IAM pour les noeud Amazon EKS
# source : https://docs.aws.amazon.com/fr_fr/eks/latest/userguide/create-node-role.html
resource "aws_iam_role" "EKSNodeGroupRole" {
  name = "EKSNodeGroupRole-${var.eks_cluster_name}-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = var.tags
}


# This policy allows Amazon EKS worker nodes to connect to Amazon EKS Clusters
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.EKSNodeGroupRole.name
}


# Provides read-only access to Amazon EC2 Container Registry repositories.
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.EKSNodeGroupRole.name
}


# This policy provides the Amazon VPC CNI Plugin (amazon-vpc-cni-k8s) the permissions it requires to modify the IP address configuration on your EKS worker nodes. 
# This permission set allows the CNI to list, describe, and modify Elastic Network Interfaces on your behalf
resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.EKSNodeGroupRole.name
}


# Configuration des worker node de type EC2
resource "aws_eks_node_group" "worker-node-ec2" {
  for_each        = { for node_group in var.workers_config : node_group.name => node_group }
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = each.value.name
  node_role_arn   = aws_iam_role.EKSNodeGroupRole.arn
  subnet_ids      = var.eks_node_groups_subnet_ids

  scaling_config {
    desired_size = try(each.value.desired_size, 1)
    max_size     = try(each.value.max_size, 2)
    min_size     = try(each.value.min_size, 1)
  }

  #ami_type       = each.value.ami_type
  instance_types = each.value.instance_types
  capacity_type  = each.value.capacity_type
  disk_size      = each.value.disk_size

  update_config {
    max_unavailable = 1
  }

  # ajout du tag pour gestion via cluster-autoscaler
  tags = merge(var.tags, { "k8s.io/cluster-autoscaler/enabled" = true, "k8s.io/cluster-autoscaler/${var.eks_cluster_name}" = "owned" })

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy
  ]
}


# certificat avec OIDC
data "tls_certificate" "eks-tls-certificat" {
  url = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}


resource "aws_iam_openid_connect_provider" "eks-openid-connect" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks-tls-certificat.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_role" "ebs_csi_driver" {
  name  = "ebs-csi-driver-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks-openid-connect.arn
        }
        Condition = {
          StringEquals = {
            "${replace(aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer, "https://", "")}:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_driver.name
}

# Configure kubeconfig using a local-exec provisioner
resource "null_resource" "configure_kubectl" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.eks-cluster.name}"
  }

  depends_on = [aws_eks_cluster.eks-cluster]
}
resource "helm_release" "aws_ebs_csi_driver" {
  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  namespace  = "kube-system"

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.ebs_csi_driver.arn
  }

  depends_on = [aws_eks_cluster.eks-cluster, null_resource.configure_kubectl]
}

resource "kubernetes_storage_class" "ebs_sc" {
  metadata {
    name = "ebs-sc"
  }

  storage_provisioner = "ebs.csi.aws.com"
  volume_binding_mode = "WaitForFirstConsumer"

  parameters = {
    type = "gp3"
  }

  depends_on = [helm_release.aws_ebs_csi_driver]
}