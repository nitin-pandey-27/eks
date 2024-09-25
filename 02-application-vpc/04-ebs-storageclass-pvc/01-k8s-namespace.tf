# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace

/*
resource "kubernetes_namespace" "wbs" {

  depends_on = [ data.terraform_remote_state.eks ]
  metadata {
    name = "wbs"
  }
}
*/