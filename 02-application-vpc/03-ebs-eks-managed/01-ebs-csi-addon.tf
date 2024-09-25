# Resource: EBS CSI Driver AddOn
# Install EBS CSI Driver using EKS Add-Ons (aws_eks_addon)
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon
# https://docs.aws.amazon.com/eks/latest/userguide/managing-ebs-csi.html

resource "aws_eks_addon" "ebs_eks_addon" {
  depends_on   = [aws_iam_role_policy_attachment.ebs_csi_iam_role_policy_attach]
  cluster_name = data.terraform_remote_state.eks.outputs.cluster_id
  addon_name   = "aws-ebs-csi-driver"
  #addon_version               = "v1.10.1-eksbuild.1"
  #resolve_conflicts_on_update = "PRESERVE"
  service_account_role_arn = aws_iam_role.ebs_csi_iam_role.arn

}