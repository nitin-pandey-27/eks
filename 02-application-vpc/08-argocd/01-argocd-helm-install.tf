# ARGOCD Install 
# https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd
# https://artifacthub.io/packages/helm/argo/argo-cd?modal=install

# helm repo add argo https://argoproj.github.io/argo-helm
# helm repo update

resource "helm_release" "argocd" {
  name      = var.argocd_name
  namespace = var.namespace
  chart     = "argo-cd"
  # version    = "6.6.0"  # If commented then use latest version can be checked here - https://artifacthub.io/packages/helm/argo/argo-cd?modal=install
  create_namespace = true
  repository       = "https://argoproj.github.io/argo-helm"

  ## https://artifacthub.io/packages/helm/argo/argo-cd

  set {
    name  = "redis-ha.enabled"
    value = "false"
  }

  set {
    name  = "controller.replicas"
    value = 1
  }

  set {
    name  = "server.autoscaling.enabled"
    value = "true"
  }

  set {
    name  = "server.autoscaling.minReplicas"
    value = 1
  }

  set {
    name  = "repoServer.autoscaling.enabled"
    value = "false"
  }

  set {
    name  = "repoServer.autoscaling.minReplicas"
    value = 1
  }

  set {
    name  = "applicationSet.replicas"
    value = 1
  }


}