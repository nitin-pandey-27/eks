# Input Variables For Cognito User Pool
variable "cognito_pool_name" {
  description = "Cognito User Pool Name"
  type        = string
  default     = "uiusers"
}

variable "deletion_protection" {
  description = "Cognito User Pool Name"
  type        = string
  default     = "INACTIVE"
}

# Input Variables For Cognito Domain Name

variable "domain_name" {
  description = "Cognito User Pool Domain Name"
  type        = string
  default     = "some-unique-name-123450123"
}

######### Input Variables For Cognito kibana  Clients 

variable "kibana_client" {
  description = "Cognito User App Client Name for kibana"
  type        = string
  default     = "kibana_client"
}

variable "kibana_callback" {
  description = "Callback URL for kibana"
  type        = string
  default     = "https://kibana.demo.oai.ai/oauth2/idpresponse"
}
# Above  value will be available from Route53. Generated after integrating Route53 and kibana ALB. 

######### Input Variables For Cognito Argocd Monitoring Clients 

variable "argocd_client" {
  description = "Cognito User App Client Name for Argocd"
  type        = string
  default     = "argocd_client"
}

variable "argocd_callback" {
  description = "Callback URL for Argocd"
  type        = string
  default     = "https://argocd.demo.oai.ai/auth/callback"
}
# Above  value will be available from Route53. Generated after integrating Route53 and ArgoCD ALB. 

variable "argocd_logout" {
  description = "Callback URL for Argocd"
  type        = string
  default     = "https://argocd.demo.oai.ai/logout"
}

######### Input Variables For Cognito Grafana  Clients 

variable "grafana_client" {
  description = "Cognito User App Client Name for Grafana"
  type        = string
  default     = "grafana_client"
}

variable "grafana_callback" {
  description = "Callback URL for Grafana"
  type        = string
  default     = "https://grafana.demo.oai.ai/oauth2/idpresponse"
}
# Above  value will be available from Route53. Generated after integrating Route53 and Grafana ALB. 

variable "grafana_logout" {
  description = "Callback URL for Grafana"
  type        = string
  default     = "https://grafana.demo.oai.ai/login"
}

######### Input Variables For Cognito ArgoCD Application Client

variable "argocd_app_client" {
  description = "Cognito User Application Client Name for ArgoCD"
  type        = string
  default     = "argocd_app_client"
}

variable "argocd_app_callback" {
  description = "Callback URL for ArgoCD Application"
  type        = string
  default     = "https://staging-argo.demo.oai.ai/auth/callback"
}
# Above  value will be available from Route53. Generated after integrating Route53 and Argocd ALB. 

variable "argocd_app_logout" {
  description = "Logout URL for ArgoCD Application"
  type        = string
  default     = "https://staging-argo.demo.oai.ai/logout"
}
# Above  value will be available from Route53. Generated after integrating Route53 and Argocd ALB. 


# Input Variables For Cognito App Clients Users

variable "username_mailid" {
  description = "Login User Mail ID"
  type        = string
  default     = "cyberslackk@gmail.com"
}


# AWS Region VARIABLES
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "sa-east-1"
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "staging"
}
# Cluster Variable
variable "cluster" {
  description = "Cluster Variable used as a prefix"
  type        = string
  default     = "app"
}
# Business Division
variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "oai"
}

# Namespace Variable
variable "namespace" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "kube-system"
}

  