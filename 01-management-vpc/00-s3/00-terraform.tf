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

  ## https://registry.terraform.io/providers/hashicorp/aws/latest

  # Adding Backend as S3 for Remote State Storage with State Locking
  /*
  backend "s3" {
    bucket = "terraform-bucket-efflou"
    key    = "application/dynamodb/terraform.tfstate"
    region = "sa-east-1"
    # For State Locking
    # dynamodb_table = "dynamodb-application-staging-psi"
    encrypt        = true
  }
  */

}