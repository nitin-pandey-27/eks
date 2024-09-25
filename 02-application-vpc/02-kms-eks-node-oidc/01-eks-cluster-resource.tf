# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
data "aws_caller_identity" "current" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition
data "aws_partition" "current" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region
data "aws_region" "current" {}



#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster

# Create AWS EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {



  name     = local.eks_cluster_name
  role_arn = aws_iam_role.eks_master_role.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids              = [data.terraform_remote_state.vpc.outputs.private_subnets_1, data.terraform_remote_state.vpc.outputs.private_subnets_2]
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    # Please refer this page for public and private endpoints
    # https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html
    public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  }

  encryption_config {
    provider {
      key_arn = aws_kms_key.kms_eks_key.arn
    }
    resources = ["secrets"]
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }

  # Enable EKS Cluster Control Plane Logging
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
    ## aws_cloudwatch_log_group.eks_control_plane_logs
  ]
  tags = {
    Name                                                  = "${var.cluster}-${var.vpc_name}-eks"
    Terraform                                             = "true"
    "k8s.io/cluster-autoscaler/${local.eks_cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"                   = "TRUE"
    "karpenter.sh/discovery"                              = "${local.eks_cluster_name}"
    "kubernetes.io/cluster/${local.eks_cluster_name}"     = "owned"
    "AWS.SSM.AppManager.EKS.Cluster.ARN"                  = "arn:${data.aws_partition.current.partition}:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/${local.eks_cluster_name}"
  }
}

