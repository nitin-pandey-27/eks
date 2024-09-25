# kibana_client Client
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client
/*
resource "aws_cognito_user_pool_client" "kibana_client" {

  depends_on = [ aws_cognito_user_pool.user_pool, aws_cognito_user_pool_domain.user_pool_domain ]

  # App Client Settings 
  user_pool_id        = aws_cognito_user_pool.user_pool.id
  name                = "${var.kibana_client}"
  generate_secret     = true
  explicit_auth_flows = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"] 

  auth_session_validity  = 15 # In Minutes 
  access_token_validity  = 15 # In Minutes 
  refresh_token_validity = 60 # In Minutes. Between 60 mins to 1 year 
  id_token_validity      = 15 # In Minutes 
  token_validity_units {
    access_token  = "minutes" 
    id_token      = "minutes"
    refresh_token = "minutes"
  }

  enable_token_revocation       = "true"
  prevent_user_existence_errors = "ENABLED"

  # Hosted UI Settings 

  callback_urls                        = ["${var.kibana_callback}"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["openid"]
  supported_identity_providers         = ["COGNITO"]

}
*/

# ArgoCD Client APPLICATION
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client

resource "aws_cognito_user_pool_client" "argocd_client" {

  depends_on = [aws_cognito_user_pool.user_pool, aws_cognito_user_pool_domain.user_pool_domain]

  # App Client Settings 
  user_pool_id        = aws_cognito_user_pool.user_pool.id
  name                = var.argocd_client
  generate_secret     = true
  explicit_auth_flows = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

  auth_session_validity  = 15 # In Minutes 
  access_token_validity  = 15 # In Minutes 
  refresh_token_validity = 60 # In Minutes. Between 60 mins to 1 year 
  id_token_validity      = 15 # In Minutes 
  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "minutes"
  }

  enable_token_revocation       = "true"
  prevent_user_existence_errors = "ENABLED"

  # Hosted UI Settings 

  callback_urls                        = ["${var.argocd_callback}"]
  logout_urls                          = ["${var.argocd_logout}"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["openid", "email", "profile"]
  supported_identity_providers         = ["COGNITO"]

}

# Grafana Client
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client


resource "aws_cognito_user_pool_client" "grafana_client" {

  depends_on = [aws_cognito_user_pool.user_pool, aws_cognito_user_pool_domain.user_pool_domain]

  # App Client Settings 
  user_pool_id        = aws_cognito_user_pool.user_pool.id
  name                = var.grafana_client
  generate_secret     = true
  explicit_auth_flows = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

  auth_session_validity  = 15 # In Minutes 
  access_token_validity  = 15 # In Minutes 
  refresh_token_validity = 60 # In Minutes. Between 60 mins to 1 year 
  id_token_validity      = 15 # In Minutes 
  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "minutes"
  }

  enable_token_revocation       = "true"
  prevent_user_existence_errors = "ENABLED"

  # Hosted UI Settings 

  callback_urls                        = ["${var.grafana_callback}"]
  logout_urls                          = ["${var.grafana_logout}"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["openid", "aws.cognito.signin.user.admin", "email", "profile"]
  supported_identity_providers         = ["COGNITO"]

}


# ArgoCD Monitoring Cluster Client
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client



resource "aws_cognito_user_pool_client" "argocd_app_client" {

  depends_on = [ aws_cognito_user_pool.user_pool, aws_cognito_user_pool_domain.user_pool_domain ]

  # App Client Settings 
  user_pool_id        = aws_cognito_user_pool.user_pool.id
  name                = "${var.argocd_app_client}"
  generate_secret     = true
  explicit_auth_flows = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"] 

  auth_session_validity  = 15 # In Minutes 
  access_token_validity  = 15 # In Minutes 
  refresh_token_validity = 60 # In Minutes. Between 60 mins to 1 year 
  id_token_validity      = 15 # In Minutes 
  token_validity_units {
    access_token  = "minutes" 
    id_token      = "minutes"
    refresh_token = "minutes"
  }

  enable_token_revocation       = "true"
  prevent_user_existence_errors = "ENABLED"

  # Hosted UI Settings 

  callback_urls                        = ["${var.argocd_app_callback}"]
  logout_urls                          = ["${var.argocd_app_logout}"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["openid","email","profile"]
  supported_identity_providers         = ["COGNITO"]

}
