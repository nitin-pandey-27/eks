# https://medium.com/@ahil.matheww/provisioning-aws-karpenter-provisioners-with-terraform-1cade400c104
# https://registry.terraform.io/providers/alon-dotan-starkware/kubectl/latest/docs
# https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/data-sources/kubectl_file_documents

data "kubectl_path_documents" "provisioner_manifests" {

  pattern = "./karpenter-provisioner-manifests/*.yaml"
  vars = {
    namespace   = "${var.namespace}"
    cluster     = "${var.cluster}"
    ami_id      = "${data.aws_ami.eks_optimized_ami.id}"
    ami_name    = "${data.aws_ami.eks_optimized_ami.name}"
    subnet_id_1 = "${data.terraform_remote_state.vpc.outputs.private_subnets_1}"
    az_zone_1   = "${var.az_zone_1}"
    subnet_id_2 = "${data.terraform_remote_state.vpc.outputs.private_subnets_2}"
    az_zone_2   = "${var.az_zone_2}"
    sg_id       = "${data.terraform_remote_state.eks.outputs.cluster_primary_security_group_id}"

    account_id          = "${data.aws_caller_identity.current.account_id}"
    karpenter_role_arn  = "${data.terraform_remote_state.karpenter.outputs.karpenter_node_group_iam_role_arn}"
    node_group_role_arn = "${data.terraform_remote_state.eks.outputs.node_group_role_arn}"
    #sg_id        = "${data.aws_security_groups.sg.id}"
    #sg_name      = "${data.aws_security_groups.sg.}"
  }
}

resource "kubectl_manifest" "provisioners" {



  for_each  = data.kubectl_path_documents.provisioner_manifests.manifests
  yaml_body = each.value
}

