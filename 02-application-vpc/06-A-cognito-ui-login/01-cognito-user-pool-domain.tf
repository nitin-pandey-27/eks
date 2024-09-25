# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_domain

resource "aws_cognito_user_pool_domain" "user_pool_domain" {

  depends_on = [aws_cognito_user_pool.user_pool]

  domain       = var.domain_name
  user_pool_id = aws_cognito_user_pool.user_pool.id

}

# A custom domain can also be created with valid certificate as mentioned in ACM Resources. 