variable "argocd_name" {
  description = "argocd name"
  type        = string
  default     = "argocd-server"
}

# Ingress Class Name 
variable "ingressClassName" {
  description = "ingressClassName"
  type        = string
  default     = "my-aws-ingress-class"
}

# Cognito Host Name
variable "argocd_host" {
  description = "argocd host name"
  type        = string
  default     = "argocd-app-demo.demo.oai.ai"
}

# Input Variables
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "sa-east-1"
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "demo"
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
# AZ
variable "az_zone_1" {
  description = "AZ_1"
  type        = string
  default     = "sa-east-1a"
}
variable "az_zone_2" {
  description = "AZ_2"
  type        = string
  default     = "sa-east-1c"
}

# EKS Cluster Version
variable "cluster_version" {
  description = "EKS cluster_version"
  type        = string
  default     = "1.29"
}