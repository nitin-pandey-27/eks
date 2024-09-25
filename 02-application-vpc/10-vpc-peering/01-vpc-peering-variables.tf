# Input Variable for VPC Link 





# AWS Region VARIABLES
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "sa-east-1"  
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type = string
  default = "staging"
}
# Cluster Variable
variable "cluster" {
  description = "Cluster Variable used as a prefix"
  type = string
  default = "app"
}
# Business Division
variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type = string
  default = "oai"
}

# Namespace Variable
variable "namespace" {
  description = "Environment Variable used as a prefix"
  type = string
  default = "kube-system"
}

  