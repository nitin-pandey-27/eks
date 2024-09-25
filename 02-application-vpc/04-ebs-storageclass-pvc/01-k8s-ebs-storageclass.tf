# Resource: Kubernetes Storage Class
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class_v1#storage_provisioner

resource "kubernetes_storage_class_v1" "ebs_sc" {
  depends_on = [data.terraform_remote_state.eks, data.terraform_remote_state.ebs-eks-managed]
  metadata {
    name = "ebs-sc"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true" # To create Network Load Balancer
    }
  }
  storage_provisioner = "ebs.csi.aws.com"
  volume_binding_mode = "WaitForFirstConsumer"
  #reclaim_policy         = "Retain"  # Default = Delete
  allow_volume_expansion = "true"
  #allowVolumeExpansion  =  "true"
  # https://kubernetes.io/docs/concepts/storage/storage-classes/#parameters
  parameters = {
    type = "gp2"
    #iopsPerGB = "5000"
    fsType    = "ext4"
    encrypted = "true"
  }
}

# https://kubernetes.io/docs/concepts/storage/storage-classes/
# https://kubernetes.io/docs/tasks/administer-cluster/change-default-storage-class/