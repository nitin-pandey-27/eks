# Route 53 Private Zone 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone

/*
resource "aws_route53_zone" "monitoring_private" {
  name = "efflou.xantav.com"

  vpc {
    vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
    vpc_region = var.aws_region
  }

  tags = {
    Terraform = true 
    Name      = "${var.environment}-${var.cluster}"
  }

}
*/

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone_association

/*
resource "aws_route53_zone_association" "secondary" {
  zone_id = data.terraform_remote_state.private_zone.outputs.monitoring_private_zone_id
  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id
}

*/


# Data Source ALB 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lbs
# ALB Name 

data "aws_lbs" "argocd_alb" {
  tags = {
    #"elbv2.k8s.aws/cluster" = "Terraform=true,load-balancer-name=common-obs-cluster"
    "load-balancer-name" = "${var.alb_name}"
  }
}

data "aws_lb" "monitoring_argocd_lb" {
  #arn  = "data.aws_lbs.argocd_alb.arns"
  name = var.alb_name
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb_hosted_zone_id
data "aws_lb_hosted_zone_id" "main" {}

# Route 53 record Private hosted Zone
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record

## ARGOCD 
/*
resource "aws_route53_record" "monitoring_private_argocd" {
  zone_id = data.terraform_remote_state.private_zone.outputs.monitoring_private_zone_id
  name    = "${var.argocd_host}"
  type    = "A"

  alias {
    name                   = data.aws_lb.monitoring_argocd_lb.dns_name
    zone_id                = data.aws_lb_hosted_zone_id.main.id
    evaluate_target_health = true
  }
}
*/

# Data Source Public ZONE
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone


data "aws_route53_zone" "public_zone" {
  name = "demoai.click."
  # private_zone = true
}

# Route 53 record Public hosted Zone
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record

### ARGOCD
resource "aws_route53_record" "monitoring_public_argocd" {
  zone_id = data.aws_route53_zone.public_zone.zone_id
  name    = var.argocd_host
  type    = "A"

  alias {
    name                   = data.aws_lb.monitoring_argocd_lb.dns_name
    zone_id                = data.aws_lb_hosted_zone_id.main.id
    evaluate_target_health = true
  }
}
