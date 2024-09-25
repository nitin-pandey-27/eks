# You may need to create workspace to avoid any error with existing workspace 
# If you see terraform plan is trying to destroy and create existing AWS Resources
# terraform init
# terraform workspace list
# terraform workspace new prod 
# terraform workspace select prod 
# terraform plan

# Cognito User Pool 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool
# https://github.com/lgallard/terraform-aws-cognito-user-pool/tree/0.23.0/examples/complete

resource "aws_cognito_user_pool" "user_pool" {

  name = var.cognito_pool_name

  username_attributes = ["email"]
  username_configuration {
    case_sensitive = true
  }
  auto_verified_attributes = ["email"]

  deletion_protection = var.deletion_protection

  password_policy {
    minimum_length                   = 8
    require_lowercase                = false
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  #mfa_configuration = "OPTIONAL"
  mfa_configuration = "ON"
  software_token_mfa_configuration {
    enabled = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "admin_only"
      priority = 1
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
    # from_email_address     = "no-reply@verificationemail.com"
    #reply_to_email_address = "no-reply@verificationemail.com"
    #source_arn             = "arn:aws:ses:us-east-1:123456789012:identity/myemail@mydomain.com"
  }

  tags = {
    tag-key   = "${var.cluster}"
    Terraform = true
  }

}
