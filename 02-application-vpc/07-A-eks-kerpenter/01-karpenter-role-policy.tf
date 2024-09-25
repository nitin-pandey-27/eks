# IAM Role for EKS Node Group 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group
# https://karpenter.sh/docs/getting-started/migrating-from-cas/

resource "aws_iam_role" "karpenter_nodegroup_role" {
  # name = "${var.environment}-${local.eks_cluster_name}-2"
  # You can comment "2" and uncomment above line. I have added because of existing EKS cluster.
  # name        = "PROD-${var.environment}-${local.eks_cluster_name}-karpenter-Node-Role"
  name = "KarpenterNodeRole-${local.eks_cluster_name}"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = {
    Name      = "${var.cluster}-eks"
    Terraform = "true"
  }
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.karpenter_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.karpenter_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.karpenter_nodegroup_role.name
}


resource "aws_iam_role_policy_attachment" "eks-AutoScalingFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = aws_iam_role.karpenter_nodegroup_role.name
}

/*
### This is not added in EKS worker node
data "aws_iam_policy" "ssm_managed_instance" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "eks-AmazonSSMManagedInstanceCore" {
  policy_arn = data.aws_iam_policy.ssm_managed_instance.arn
  role       = aws_iam_role.karpenter_nodegroup_role.name
}
*/

resource "aws_iam_instance_profile" "karpenter" {
  name = "KarpenterNodeInstanceProfile-${local.eks_cluster_name}"
  role = aws_iam_role.karpenter_nodegroup_role.name
}

/*
# Autoscaling Full Access
# https://github.com/kubernetes/autoscaler/tree/master/charts/cluster-autoscaler
resource "aws_iam_role_policy_attachment" "eks-Autoscaling-Full-Access" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = aws_iam_role.karpenter_nodegroup_role.name
}

*/


## Resource: IAM Role for Karpenter
## Create IAM Role and associate it with Karpenter IAM Policy
resource "aws_iam_role" "karpenter_assume_iam_role" {
  #name = "${local.name}-cluster-autoscaler"
  # name        = "PROD-${var.environment}-${local.eks_cluster_name}-karpenter-Assume-Role"
  name = "KarpenterControllerRole-${local.eks_cluster_name}"

  # Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "${data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_arn}"
        }
        Condition = {
          StringEquals = {
            "${data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_extract_from_arn}:sub" : "system:serviceaccount:karpenter:karpenter"
          }
        }
      },
    ]
  })

  tags = {
    tag-key   = "Karpenter"
    Name      = "${var.cluster}-${var.environment}-eks"
    Terraform = "true"
  }
}


## Karpenter Policy Attachment 

resource "aws_iam_policy" "karpenter_controller_policy" {
  policy = file("./01-controller-trust-policy.json")
  name   = "KarpenterControllerPolicy-${local.eks_cluster_name}"
}

resource "aws_iam_role_policy_attachment" "karpenter_controller_attach" {
  role       = aws_iam_role.karpenter_assume_iam_role.name
  policy_arn = aws_iam_policy.karpenter_controller_policy.arn
}
