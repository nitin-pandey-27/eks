# Resource: ACM Certificate
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate
# https://stackoverflow.com/questions/55410675/imported-ssl-cert-not-listed-for-alb-listener
# NOTE: ALB does not support 4096. 2048 is supported with ACM integration.


resource "aws_acm_certificate" "acm_cert" {
  domain_name       = "*.demoai.click"
  validation_method = "DNS"

  tags = {
    Environment = "common"
    Name        = "${var.environment}-acm"
    Terraform   = "true"
  }

  lifecycle {
    create_before_destroy = true
    # https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle
  }
}

# Certificate Validation 
# https://dev.to/aws-builders/create-acm-certificate-with-dns-validation-using-terraform-2adf
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation

data "aws_route53_zone" "public_zone" {
  name         = "demoai.click"
  private_zone = false
}


resource "aws_route53_record" "acm_cert_record" {
  depends_on = [aws_acm_certificate.acm_cert, data.aws_route53_zone.public_zone]
  for_each = {
    for dvo in aws_acm_certificate.acm_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.public_zone.zone_id
}

resource "aws_acm_certificate_validation" "acm_cert_validation" {
  depends_on              = [aws_route53_record.acm_cert_record]
  certificate_arn         = aws_acm_certificate.acm_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_cert_record : record.fqdn]
}





/*

# RSA key of size 2048 bits
resource "tls_private_key" "rsa-4096-example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "example" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.rsa-4096-example.private_key_pem

  subject {
    common_name  = "demo.xyz.com"
    organization = "oai"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}
*/

/*
resource "aws_acm_certificate" "acm_cert" {
  #private_key      = tls_private_key.rsa-4096-example.private_key_pem
  #certificate_body = tls_self_signed_cert.example.cert_pem

  private_key      = file("${path.module}/cert-key/client.key")
  certificate_body = file("${path.module}/cert-key/client.pem")

  #domain_name       = "demo.xyz.com"
  #validation_method = "EMAIL"

  tags = {
    Environment = "${local.name}"
  }

  lifecycle {
    create_before_destroy = true
   }
}
*/

/*
resource "aws_acm_certificate" "acm_cert-2" {
  #private_key      = tls_private_key.rsa-4096-example.private_key_pem
  #certificate_body = tls_self_signed_cert.example.cert_pem

  private_key      = file("${path.module}/cert-key/xyz-demo.key")
  certificate_body = file("${path.module}/cert-key/xyz-demo.pem")

  #domain_name       = "demo.xyz.com"
  #validation_method = "EMAIL"

  tags = {
    Environment = "${local.name}"
  }

  lifecycle {
    create_before_destroy = true
   }
}
*/