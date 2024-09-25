##https://developer.hashicorp.com/terraform/language/settings/backends/local
##https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state

/*
data "terraform_remote_state" "s3" {
  backend = "s3"
  config = {
    bucket = "ai-demo-terraform-state"
    key    = "management/s3-logs/terraform.tfstate"
    region = "us-east-2"
  }
}
*/