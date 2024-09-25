# Cognito Output
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool#attribute-reference

output "user_pool_arn" {
  description = "ARN of Cognito User Pool"
  value       = aws_cognito_user_pool.user_pool.arn
}

output "user_pool_creation_date" {
  description = "Creation Date of Cognito User Pool"
  value       = aws_cognito_user_pool.user_pool.creation_date
}

output "user_pool_endpoint" {
  description = "Endpoint of Cognito User Pool"
  value       = aws_cognito_user_pool.user_pool.endpoint
}

output "user_pool_id" {
  description = "ID of Cognito User Pool"
  value       = aws_cognito_user_pool.user_pool.id
}

output "user_pool_last_modified_date" {
  description = "Last Modification Date of Cognito User Pool"
  value       = aws_cognito_user_pool.user_pool.last_modified_date
}

output "user_pool_estimated_users" {
  description = "Estimated Number of Users in Cognito User Pool"
  value       = aws_cognito_user_pool.user_pool.estimated_number_of_users
}

# Domain Output

output "user_pool_domain" {
  description = "Domain Name of Cognito User Pool"
  value       = aws_cognito_user_pool_domain.user_pool_domain.domain
}

# Kibana Client Output
/*
output "kibana_mon_client_id" {
  description = "ID of kibana app client"
  value = aws_cognito_user_pool_client.kibana_client.id
}

output "kibana_mon_client_secret" {
  description = "ID of kibana app client"
  sensitive = true
  value = aws_cognito_user_pool_client.kibana_client.client_secret
}
*/

# ArgoCD Client Output

output "argocd_app_client_id" {
  description = "ID of argocd monitoring client"
  value       = aws_cognito_user_pool_client.argocd_client.id
}

output "argocd_app_client_secret" {
  description = "Secret of argocd monitoring client"
  sensitive   = true
  value       = aws_cognito_user_pool_client.argocd_client.client_secret
}


# Grafana Client Output

output "grafana_mon_client_id" {
  description = "ID of Grafana app client"
  value       = aws_cognito_user_pool_client.grafana_client.id
}

output "grafana_mon_client_secret" {
  description = "ID of Grafana app client"
  sensitive   = true
  value       = aws_cognito_user_pool_client.grafana_client.client_secret
}


/*
# ArgoCD Application Client Output

output "argocd_app_client_id" {
  description = "ID of ArgoCD application client"
  value = aws_cognito_user_pool_client.argocd_app_client.id
}

output "argocd_app_client_secret" {
  description = "ID of ArgoCD application client"
  sensitive = true
  value = aws_cognito_user_pool_client.argocd_app_client.client_secret
}
*/

# Login User Output 

/*
output "login_user_status" {
  description = "Username to login to  UI"
  value = aws_cognito_user.login_user.status
}

output "login_user_mfa_preference" {
  description = "Username to login to  UI"
  value       = aws_cognito_user.login_user.preferred_mfa_setting
}
*/