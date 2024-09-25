##https://developer.hashicorp.com/terraform/language/settings/backends/local
##https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state


data "terraform_remote_state" "vpc_application_prod" {
  backend = "s3"
  config = {
    bucket = "ai-demo-terraform-state"
    key    = "application/vpc/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "vpc_monitoring" {
  backend = "s3"
  config = {
    bucket = "ai-demo-terraform-state"
    key    = "monitoring/vpc/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "vpc_peering" {
  backend = "s3"
  config = {
    bucket = "ai-demo-terraform-state"
    key    = "application/vpc-peering/terraform.tfstate"
    region = "us-east-2"
  }
}



/*
data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "ai-demo-terraform-state"
    key    = "application/eks/terraform.tfstate"
    region = "us-east-2"
  }
}

*/