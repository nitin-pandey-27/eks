# Resource: Persistent Volume Claim
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim_v1
# This won't be created unless you have a POD running.

/*
resource "kubernetes_persistent_volume_claim_v1" "pvc" {
  depends_on = [ kubernetes_storage_class_v1.ebs_sc, kubernetes_namespace.wbs ]
  metadata {
    name = "ebs-mysql-pv-claim"
    namespace = var.namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = kubernetes_storage_class_v1.ebs_sc.metadata.0.name 
    resources {
      requests = {
        storage = "4Gi"
      }
    }
  }
}
*/