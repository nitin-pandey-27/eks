##https://developer.hashicorp.com/terraform/language/settings/backends/local
##https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "ai-demo-terraform-state"
    key    = "management/vpc/terraform.tfstate"
    region = "us-east-2"
  }
}