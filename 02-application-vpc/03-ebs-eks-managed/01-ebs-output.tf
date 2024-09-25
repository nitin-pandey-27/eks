# Output Body for the EBS-CSI-HTTP-POLICY
output "ebs_csi_iam_policy" {
  value = data.http.ebs_csi_iam_policy.response_body
}

# Output EKS IAM Policy ARN
output "ebs_csi_iam_policy_arn" {
  value = aws_iam_policy.ebs_csi_iam_policy.arn
}

# Output AWS Account ID 
output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

# Output EKS IAM Role ARN
output "ebs_csi_iam_role_arn" {
  description = "EBS CSI IAM Role ARN"
  value       = aws_iam_role.ebs_csi_iam_role.arn
}

# EKS AddOn - EBS CSI Driver Outputs 
output "ebs_eks_addon_arn" {
  description = "EKS AddOn - EBS CSI Driver ARN"
  value       = aws_eks_addon.ebs_eks_addon.arn
}
output "ebs_eks_addon_id" {
  description = "EKS AddOn - EBS CSI Driver ID"
  value       = aws_eks_addon.ebs_eks_addon.id
}