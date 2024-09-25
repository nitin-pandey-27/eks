# https://medium.com/@ahil.matheww/provisioning-aws-karpenter-provisioners-with-terraform-1cade400c104
# https://registry.terraform.io/providers/alon-dotan-starkware/kubectl/latest/docs
# https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/data-sources/kubectl_file_documents

data "kubectl_path_documents" "provisioner_manifests" {
  pattern = "./eks-provisioner-manifests/*.yaml"
  vars = {
    account_id          = "${data.aws_caller_identity.current.account_id}"
    node_group_role_arn = "${data.terraform_remote_state.eks.outputs.node_group_role_arn}"

  }
}

resource "kubectl_manifest" "provisioners" {
  for_each  = data.kubectl_path_documents.provisioner_manifests.manifests
  yaml_body = each.value
}

