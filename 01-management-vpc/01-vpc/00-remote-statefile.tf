##https://developer.hashicorp.com/terraform/language/settings/backends/local
##https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state

/*
data "terraform_remote_state" "s3-dynamodb" {
  backend = "local"

  config = {
    #path = "../../obs/terraform.tfstate"
    path = "../00-s3/terraform.tfstate"

  }
}
*/