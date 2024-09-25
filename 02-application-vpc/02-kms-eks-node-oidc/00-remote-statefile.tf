##https://developer.hashicorp.com/terraform/language/settings/backends/local
##https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state


data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "ai-demo-terraform-state"
    key    = "application/vpc/terraform.tfstate"
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