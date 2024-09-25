# Storage Class Output 
output "storage_class" {
  description = "Storage Class UID"
  value       = kubernetes_storage_class_v1.ebs_sc.id
}

/*
output "namespace" {
   description = "namespace name"
   value       = kubernetes_namespace.wbs.id
}
*/

/*
# PVC Output 
output "pvc" {
   description = "PVC ID"
   value       = kubernetes_persistent_volume_claim_v1.pvc.id
}
*/