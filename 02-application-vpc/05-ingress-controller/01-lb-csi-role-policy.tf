#data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_arn
#data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_extract_from_arn
#https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html 

# Resource: Create AWS Load Balancer Controller IAM Policy 
resource "aws_iam_policy" "lbc_iam_policy" {
  depends_on  = [data.terraform_remote_state.eks]
  name        = "${var.environment}-${local.eks_cluster_name}-LB-Policy"
  path        = "/"
  description = "AWS Load Balancer Controller IAM Policy"
  policy      = data.http.lbc_iam_policy.response_body
  #policy = data.http.lbc_iam_policy.body

  tags = {
    tag-key   = "AWSLoadBalancerControllerIAMPolicy"
    Name      = "${var.cluster}-${var.environment}-eks"
    Terraform = "true"
  }

}

# Resource: Create IAM Role 
resource "aws_iam_role" "lbc_iam_role" {
  name = "${var.environment}-${local.eks_cluster_name}-LB-Role"

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
            "${data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_extract_from_arn}:aud" : "sts.amazonaws.com",
            "${data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_extract_from_arn}:sub" : "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      },
    ]
  })

  tags = {
    tag-key   = "AWSLoadBalancerControllerIAMPolicy"
    Name      = "${var.cluster}-${var.environment}-eks"
    Terraform = "true"
  }
}

# Associate Load Balanacer Controller IAM Policy to  IAM Role
resource "aws_iam_role_policy_attachment" "lbc_iam_role_policy_attach" {
  policy_arn = aws_iam_policy.lbc_iam_policy.arn
  role       = aws_iam_role.lbc_iam_role.name
}
