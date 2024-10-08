# Resource: Kubernetes Ingress Class
# https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.6/guide/ingress/ingress_class/
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_class_v1

resource "kubernetes_ingress_class_v1" "ingress_class_default" {
  depends_on = [helm_release.loadbalancer_controller, data.terraform_remote_state.eks]
  metadata {
    name = "my-aws-ingress-class"
    annotations = {
      "ingressclass.kubernetes.io/is-default-class" = "true"
    }
  }
  spec {
    controller = "ingress.k8s.aws/alb"
  }
}

## Additional Note
# 1. You can mark a particular IngressClass as the default for your cluster. 
# 2. Setting the ingressclass.kubernetes.io/is-default-class annotation to true on an IngressClass resource will ensure that new Ingresses without an ingressClassName field specified will be assigned this default IngressClass.  
# 3. Reference: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.6/guide/ingress/ingress_class/