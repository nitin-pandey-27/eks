##https://developer.hashicorp.com/terraform/language/settings/backends/local
##https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
data "aws_caller_identity" "current" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition
data "aws_partition" "current" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region
data "aws_region" "current" {}


data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "ai-demo-terraform-state"
    key    = "application/vpc/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "ai-demo-terraform-state"
    key    = "application/eks/terraform.tfstate"
    region = "us-east-2"
  }
}

data "aws_ami" "eks_optimized_ami" {
  most_recent = true
  owners      = ["${data.aws_caller_identity.current.account_id}"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.cluster_version}-v*"]
  }
}

data "aws_security_groups" "sg" {
  tags = {
    "kubernetes.io/cluster/${var.cluster}" = "owned"
    "aws:eks:cluster-name"                 = "${var.cluster}"

  }
}

data "terraform_remote_state" "karpenter" {
  backend = "s3"
  config = {
    bucket = "ai-demo-terraform-state"
    key    = "application/karpenter/terraform.tfstate"
    region = "us-east-2"
  }
}