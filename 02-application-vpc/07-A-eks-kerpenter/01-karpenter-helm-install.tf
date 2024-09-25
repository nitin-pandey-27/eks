# https://karpenter.sh/
# https://github.com/aws/karpenter
# https://github.com/aws/karpenter/tree/main/charts/karpenter
# https://gallery.ecr.aws/karpenter/karpenter
# https://karpenter.sh/docs/getting-started/migrating-from-cas/
# https://karpenter.sh/docs/getting-started/getting-started-with-karpenter/
# https://medium.com/@ahil.matheww/provisioning-aws-karpenter-provisioners-with-terraform-1cade400c104

# NOTE: Before running "terraform apply" please configure the "aws-auth" configmap of EKS cluster 
# Take the backup of existing "aws-auth"  "kubectl -n kube-system get cm aws-auth -o yaml > original-aws-auth-cm.yaml"
# Edit this manually "kubectl -n kube-system edit cm aws-auth"
# Append the new map as mentioned in this file "01-karpenter-aws-auth-cm.yaml"
# Then after executing the "terraform apply" execute the provisioner 
# PLEASE EDIT "01-karpenter-provisioner.yaml" FILE AS PER YOUR SG and SUBNET IDs IN VPC
# kubectl apply -f 01-karpenter-provisioner.yaml

resource "helm_release" "karpenter" {
  namespace        = "karpenter"
  create_namespace = true

  name       = "karpenter"
  repository = "oci://public.ecr.aws/karpenter/"
  chart      = "karpenter"
  version    = "1.0.0"
  ##version    = "v0.32.1"

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.karpenter_assume_iam_role.arn
  }


  set {
    name  = "settings.aws.clusterName"
    value = data.terraform_remote_state.eks.outputs.cluster_id
  }
  set {
    name  = "settings.clusterName"
    value = data.terraform_remote_state.eks.outputs.cluster_id
  }


  set {
    name  = "settings.aws.clusterEndpoint"
    value = data.terraform_remote_state.eks.outputs.cluster_endpoint
  }
  set {
    name  = "settings.clusterEndpoint"
    value = data.terraform_remote_state.eks.outputs.cluster_endpoint
  }


  set {
    name  = "settings.aws.defaultInstanceProfile"
    value = aws_iam_instance_profile.karpenter.name
  }
  set {
    name  = "settings.defaultInstanceProfile"
    value = aws_iam_instance_profile.karpenter.name
  }


  set {
    name  = "settings.aws.interruptionQueueName"
    value = data.terraform_remote_state.eks.outputs.cluster_id
  }
  set {
    name  = "settings.interruptionQueueName"
    value = data.terraform_remote_state.eks.outputs.cluster_id
  }



  /*
  set {
    name  = "aws.clusterName"
    value = "${local.eks_cluster_name}"
  }

  set {
    name  = "aws.clusterEndpoint"
    value = "${data.terraform_remote_state.eks.outputs.cluster_endpoint}"
  }
 

    set {
    name  = "clusterName"
    value = "${local.eks_cluster_name}"
  }

  set {
    name  = "clusterEndpoint"
    value = "${data.terraform_remote_state.eks.outputs.cluster_endpoint}"
  }
  

  set {
    name  = "aws.interruptionQueue"
    value = "${local.eks_cluster_name}"
  }

  set {
    name  = "aws.defaultInstanceProfile"
    value = aws_iam_instance_profile.karpenter.name
  }
   
  set {
    name = "karpenter-cert"
    value = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
  }

  set {
    name  = "cluster-name"
    value = "${local.eks_cluster_name}"
  }
  */

  depends_on = [aws_iam_role.karpenter_assume_iam_role, aws_iam_role.karpenter_nodegroup_role]
}


