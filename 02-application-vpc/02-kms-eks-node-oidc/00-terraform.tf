#####################################################################
#  Terraform Settings Block
terraform {
  required_version = "~> 1.9.5" # means any version equal or greater than 1.5.6 and less than 1.6
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.64.0"
    }
  }

  # Adding Backend as S3 for Remote State Storage with State Locking
  # https://developer.hashicorp.com/terraform/language/settings/backends/s3
  # NOTE: Variables may not be used here 

  backend "s3" {
    bucket = "ai-demo-terraform-state"
    key    = "application/eks/terraform.tfstate"
    region = "us-east-2"

    # For State Locking
    # dynamodb_table = "ai-demo-terraform-lock"
  }


}