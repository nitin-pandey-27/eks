# Cognito User 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user

# Login  User

/*
resource "aws_cognito_user" "login_user" {

  depends_on = [ aws_cognito_user_pool_client.opensearch_client ]

  user_pool_id = aws_cognito_user_pool.user_pool.id
  #username     = aws_cognito_user.create_user.username
  username     = "${var.username_mailid}"

  
  attributes = {
    #email             = "cyberslackk@gmail.com"
    #mfa_configuration = "ON"
  }


  desired_delivery_mediums = ["EMAIL"]
  enabled                  = true
  #message_action           = "RESEND" 

}

*/