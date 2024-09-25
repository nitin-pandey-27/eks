# Output Body for the LB-CSI-HTTP-POLICY
output "lbc_csi_iam_policy" {
  value = data.http.lbc_iam_policy.response_body
}
# Output LB IAM Policy ARN
output "lbc_csi_iam_policy_arn" {
  value = aws_iam_policy.lbc_iam_policy.arn
}

# Output LB IAM Role ARN
output "lbc_csi_iam_role_arn" {
  description = "AWS Load Balancer Controller IAM Role ARN"
  value       = aws_iam_role.lbc_iam_role.arn
}

# LB CSI Helm Release Outputs
output "lbc_csi_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value       = helm_release.loadbalancer_controller.metadata
}

