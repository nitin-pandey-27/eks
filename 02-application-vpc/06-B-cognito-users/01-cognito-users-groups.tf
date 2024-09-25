# Cognito User 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user

# Login  User
#### COMMENT ONE RESOURCE IF YOU DONT WANT TO ADD NEW USER
#### CREATE A NEW RESOURCE IF YOU WANT TO ADD NEW USER

/*
resource "aws_cognito_user" "login_user" {

  #depends_on = [ aws_cognito_user_pool_client.opensearch_client ]

  user_pool_id = data.terraform_remote_state.cognito_user_pool.outputs.user_pool_id

  username     = "${var.username_mailid}"

  
  attributes = {
    #email             = "cyberslackk@gmail.com"
    #mfa_configuration = "ON"
  }


  desired_delivery_mediums = ["EMAIL"]
  enabled                  = false
  #message_action           = "RESEND" 

}
*/

#### COMMENT THIS IF YOU DONT WANT TO ADD NEW USER
#### CREATE A NEW RESOURCE IF YOU WANT TO ADD NEW USER
resource "aws_cognito_user" "login_user_2" {

  #depends_on = [ aws_cognito_user_pool_client.opensearch_client ]

  user_pool_id = data.terraform_remote_state.cognito_user_pool.outputs.user_pool_id

  username = var.username_mailid2


  attributes = {
    email = "${var.username_mailid2}"
    #mfa_configuration = "ON"
  }


  desired_delivery_mediums = ["EMAIL"]
  enabled                  = true
  #message_action           = "RESEND" 

}

/*
resource "aws_cognito_user" "login_user_3" {

  #depends_on = [ aws_cognito_user_pool_client.opensearch_client ]

  user_pool_id = data.terraform_remote_state.cognito_user_pool.outputs.user_pool_id

  username     = "${var.username_mailid3}"

  
  attributes = {
    email             = "${var.username_mailid3}"
    #mfa_configuration = "ON"
  }


  desired_delivery_mediums = ["EMAIL"]
  enabled                  = true
  #message_action           = "RESEND" 

}
*/

# Login  Group
# ArgoCD Login Group
# https://github.com/argoproj/argo-cd/discussions/7955
# https://gist.github.com/vavdoshka/f180bc49886728d9f051d9c4db045f9e
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_group

/*

resource "aws_cognito_user_group" "login_group_argocd" {
  name         = "argocd-admin"

  user_pool_id = aws_cognito_user_pool.user_pool.id
  description  = "Managed by Terraform"
}


# Login  Group
# Grafana Login Group
# https://community.grafana.com/t/configure-auth-generic-oauth-with-aws-cognito/90771
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_group

resource "aws_cognito_user_group" "login_group_grafana" {
  name         = "grafana-admin"

  user_pool_id = aws_cognito_user_pool.user_pool.id
  description  = "Managed by Terraform"
}

*/