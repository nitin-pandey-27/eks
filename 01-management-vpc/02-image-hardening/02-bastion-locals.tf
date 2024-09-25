# Define Local Values in Terraform
locals {
  owners      = var.business_divsion
  environment = var.environment
  name        = "${var.cluster}-${var.environment}-${var.business_divsion}"
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
} 