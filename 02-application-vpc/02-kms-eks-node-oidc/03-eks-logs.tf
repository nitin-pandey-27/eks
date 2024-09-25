##########################
## ENABLE LOG RETENTION For EKS CONTROL PLANE LOGS
## It is recommended to change this settings while EKS CLUSTER CREATION
##  
## BELOW WILL WORK WITH NO EKS CLUSTER. SO, either you delete EKS CW Log group or ADD BELOW LINEs
## 02-kms-eks-node-oidc -> 01-eks-cluster.resource.tf

/*
resource "aws_cloudwatch_log_group" "eks_control_plane_logs" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html

  depends_on = [ aws_kms_key.kms_eks_key ]

  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 5 # Change this as per customer requirement 
  # expected retention_in_days to be one of [0 1 3 5 7 14 30 60 90 120 150 180 365 400 545 731 1096 1827 2192 2557 2922 3288 3653]

  # kms_key_id  = aws_kms_key.kms_eks_key.id

  tags = {
    Terraform   =  true
  }

}
*/


/*

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudwatch_log_groups
data "aws_cloudwatch_log_groups" "eks_control_plane_logs" {
  log_group_name_prefix = "/aws/eks/${var.cluster_name}"
} 


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
resource "aws_cloudwatch_log_group" "eks_control_plane_logs_2" {

  for_each = toset("${data.aws_cloudwatch_log_groups.eks_control_plane_logs.log_group_names}")
  
  name =  each.value

  retention_in_days = 5 # Change this as per customer requirement 
  # expected retention_in_days to be one of [0 1 3 5 7 14 30 60 90 120 150 180 365 400 545 731 1096 1827 2192 2557 2922 3288 3653]

  kms_key_id  = aws_kms_key.kms_eks_key.id

  tags = {
    Terraform   =  true
  }

}
*/

