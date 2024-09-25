# Monitoring AWS Route 53 Private Zone 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone


# Monitoring AWS Route 53 Recrod 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record#attribute-reference

/*
output "application_private_zone_record" {
  description = "application_private_zone_record"
  value       = aws_route53_record.monitoring_private_argocd.fqdn
}
*/

output "application_public_zone_record" {
  description = "application_public_zone_record"
  value       = aws_route53_record.monitoring_public_argocd.fqdn
}