# Datasource: AWS Partition
# Use this data source to lookup information about the current AWS partition in which Terraform is working
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition
#data "aws_partition" "current" {}

# Resource: AWS IAM Open ID Connect Provider
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider#example-usage
resource "aws_iam_openid_connect_provider" "oidc_provider" {

  # References in depends_on must be to a whole object (resource, etc), not to an attribute of an object.
  depends_on = [aws_eks_cluster.eks_cluster]

  client_id_list  = ["sts.${data.aws_partition.current.dns_suffix}"]
  thumbprint_list = [var.eks_oidc_root_ca_thumbprint]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer

  tags = merge(
    {
      Name      = "${local.eks_cluster_name}"
      Terraform = "true"
    },
    local.common_tags
  )
}