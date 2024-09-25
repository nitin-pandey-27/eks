# https://medium.com/@ahil.matheww/provisioning-aws-karpenter-provisioners-with-terraform-1cade400c104
# https://registry.terraform.io/providers/alon-dotan-starkware/kubectl/latest/docs
# https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/data-sources/kubectl_file_documents

data "kubectl_path_documents" "provisioner_manifests" {



  pattern = "./argocd-manifests/*.yaml"
  vars = {
    ## Related with NodePort Service
    namespace    = "${var.namespace}"
    argocd_name  = "${var.argocd_name}"
    service-name = "${var.argocd_name}-node-port"
    ## Ingress Related
    ingress-argocd = "ingress-${var.argocd_name}"
    ##certificate_arn  = "arn:aws:acm:sa-east-1:278671418314:certificate/3b783545-1cb1-4c16-aa30-ac3b4ea6507e"
    ingressClassName = "${var.ingressClassName}"
    argocd_host      = "${var.argocd_host}"
    ## Cognito Related 
    userPoolARN      = "${data.terraform_remote_state.cognito.outputs.user_pool_arn}"
    userPoolClientID = "${data.terraform_remote_state.cognito.outputs.argocd_app_client_id}" # This needs to be changed as per environment
    userPoolDomain   = "${data.terraform_remote_state.cognito.outputs.user_pool_domain}"
    userPoolID       = "${data.terraform_remote_state.cognito.outputs.user_pool_id}"
    aws_region       = "${var.aws_region}"
    ##s3_bucket        = "${data.terraform_remote_state.s3_logs.outputs.s3_bucket_id}"
    certificate_arn = "${data.terraform_remote_state.acm.outputs.acm_certificate_arn}"

  }
}

resource "kubectl_manifest" "provisioners" {
  depends_on = [ helm_release.argocd ]

  for_each  = data.kubectl_path_documents.provisioner_manifests.manifests
  yaml_body = each.value
}



