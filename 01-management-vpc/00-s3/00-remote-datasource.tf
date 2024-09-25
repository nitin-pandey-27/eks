##https://developer.hashicorp.com/terraform/language/settings/backends/local
##https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state

/*
data "terraform_remote_state" "eks" {
  backend = "local"

  config = {
    #path = "../../obs/terraform.tfstate"
    path  = "../vpc-eks/terraform.tfstate"
  }
}
*/