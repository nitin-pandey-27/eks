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
    key    = "monitoring/vpc/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "ai-demo-terraform-state"
    key    = "monitoring/eks/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "cognito" {
  backend = "s3"
  config = {
    bucket = "ai-demo-terraform-state"
    key    = "application/cognitoui/terraform.tfstate"
    region = "us-east-2"
  }
}

/*
data "terraform_remote_state" "s3_logs" {
  backend = "s3"
  config = {
    bucket = "ai-demo-terraform-state"
    key    = "management/s3-logs/terraform.tfstate"
    region = "us-east-2"
  }
}
*/

data "terraform_remote_state" "acm" {
  backend = "s3"
  config = {
    bucket = "ai-demo-terraform-state"
    key    = "management/acm/terraform.tfstate"
    region = "us-east-2"
  }
}