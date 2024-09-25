#data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_arn
#data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_extract_from_arn

# Resource: Create EBS CSI IAM Policy 
resource "aws_iam_policy" "ebs_csi_iam_policy" {
  #name        = "${local.name}-AmazonEKS_EBS_CSI_Driver_Policy"
  name        = "application-${var.environment}-${local.eks_cluster_name}"
  path        = "/"
  description = "EBS CSI IAM Policy"
  policy      = data.http.ebs_csi_iam_policy.response_body
  # Taken from http data source 
  tags = {
    Name      = "${var.cluster}-${var.environment}-eks"
    Terraform = "true"
  }
}

# Resource:  Create IAM Role and associate the EBS IAM Policy to it
resource "aws_iam_role" "ebs_csi_iam_role" {
  #name = "${local.name}-ebs-csi-iam-role"
  name = "application-${var.environment}-${local.eks_cluster_name}"

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
            "${data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_extract_from_arn}:sub" : "system:serviceaccount:kube-system:ebs-csi-controller-sa"
            # "system:serviceaccount:kube-system:ebs-csi-controller-sa"
            # kube-system --> default namespace for ebs csi driver 
            # ebs-csi-controller-sa --> ebs-csi controller service account name. 
            # No need to change anything else 
          }
        }

      },
    ]
  })

  tags = {
    Name      = "${var.cluster}-${var.environment}-eks"
    Terraform = "true"
  }
}

# Associate EBS CSI IAM Policy to EBS CSI IAM Role
resource "aws_iam_role_policy_attachment" "ebs_csi_iam_role_policy_attach" {
  policy_arn = aws_iam_policy.ebs_csi_iam_policy.arn
  role       = aws_iam_role.ebs_csi_iam_role.name
}

