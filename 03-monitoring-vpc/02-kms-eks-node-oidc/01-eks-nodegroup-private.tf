# https://wangpp.medium.com/terraform-eks-nodegroups-with-custom-launch-templates-5b6a199947f
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#placement
# NOTE: Change the cluster name line # 27

resource "aws_launch_template" "eks_launch_template" {
  name = "${local.eks_cluster_name}_launch_template"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 10
      volume_type = "gp2"
      encrypted   = true
    }
  }

  #image_id = "ami-013d6543fda1a65d9"
  image_id = data.aws_ami.eks_optimized_ami.id
  ##instance_type = "c5.2xlarge"
  ##instance_type = "t4g.small"
  ##instance_type = "t2.micro"
  instance_type = "t3.medium"

  user_data = base64encode(<<-EOF
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="
--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
/etc/eks/bootstrap.sh monitoring-cluster
--==MYBOUNDARY==--\
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name      = "${local.eks_cluster_name}-Node-Group"
      Terraform = "true"
      # Cluster Autoscaler Tags
      # https://docs.aws.amazon.com/eks/latest/userguide/autoscaling.html
      # https://github.com/kubernetes/autoscaler/tree/master/charts/cluster-autoscaler
      "k8s.io/cluster-autoscaler/${local.eks_cluster_name}" = "owned"
      "k8s.io/cluster-autoscaler/enabled"                   = "TRUE"
      "karpenter.sh/discovery"                              = "${local.eks_cluster_name}"
      "kubernetes.io/cluster/${local.eks_cluster_name}"     = "owned"
      "AWS.SSM.AppManager.EKS.Cluster.ARN"                  = "arn:${data.aws_partition.current.partition}:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/${local.eks_cluster_name}"
    }
  }
}



#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group

# Create AWS EKS Node Group - Private
resource "aws_eks_node_group" "eks_ng_private" {
  cluster_name = aws_eks_cluster.eks_cluster.name

  #node_group_name = "cluster-1-${local.name}-eks-ng-private"
  node_group_name = local.eks_cluster_name
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = [data.terraform_remote_state.vpc.outputs.private_subnets_1, data.terraform_remote_state.vpc.outputs.private_subnets_2]
  #version         = var.cluster_version #(Optional: Defaults to EKS Cluster Kubernetes version)   

  #ami_type = "AL2_x86_64"   
  ami_type = "CUSTOM" # Require launch template to define
  launch_template {
    name    = aws_launch_template.eks_launch_template.name
    version = aws_launch_template.eks_launch_template.latest_version
  }
  #disk_size = 20
  #instance_types = ["t3.large"]

  capacity_type = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 6
  }

  # Desired max percentage of unavailable worker nodes during node group update.
  update_config {
    max_unavailable = 1
    #max_unavailable_percentage = 50    # ANY ONE TO USE
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = {
    Name      = "${local.eks_cluster_name}-Node-Group"
    Terraform = "true"
    # Cluster Autoscaler Tags
    # https://docs.aws.amazon.com/eks/latest/userguide/autoscaling.html
    # https://github.com/kubernetes/autoscaler/tree/master/charts/cluster-autoscaler
    "k8s.io/cluster-autoscaler/${local.eks_cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"                   = "TRUE"
    "karpenter.sh/discovery"                              = "${local.eks_cluster_name}"
    "kubernetes.io/cluster/${local.eks_cluster_name}"     = "owned"
    "AWS.SSM.AppManager.EKS.Cluster.ARN"                  = "arn:${data.aws_partition.current.partition}:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/${local.eks_cluster_name}"
    #"AWS.SSM.AppManager.EKS.Cluster.ARN"                  = "arn:aws:eks:sa-east-1:278671418314:cluster/${local.eks_cluster_name}"

  }

}
