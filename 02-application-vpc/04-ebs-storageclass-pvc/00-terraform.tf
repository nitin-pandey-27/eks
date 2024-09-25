#####################################################################
#  Terraform Settings Block

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs
#https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#example-usage

terraform {
  required_version = "~> 1.9.5" # means any version equal or greater than 1.5.6 and less than 1.6
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.64.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.32.0"
    }
    /*
    terraform = {
      source = "hashicorp/terraform"
      version = "1.0.2"
    }
    */
  }

  backend "s3" {
    bucket = "ai-demo-terraform-state"
    key    = "application/pvc/terraform.tfstate"
    region = "us-east-2"

    # For State Locking
    # dynamodb_table = "ai-demo-terraform-lock"
  }

}