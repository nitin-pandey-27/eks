##https://developer.hashicorp.com/terraform/language/settings/backends/local
##https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "ai-demo-terraform-state"
    key    = "application/eks/terraform.tfstate"
    region = "us-east-2"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
# data "aws_caller_identity" "current" {}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition
data "aws_partition" "current" {}       

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region
data "aws_region" "current" {}
