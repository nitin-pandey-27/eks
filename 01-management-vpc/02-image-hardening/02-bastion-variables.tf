# AWS EC2 Instance Terraform Variables

# AWS EC2 Instance Type
variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

# AWS EC2 Instance Key Pair
variable "instance_keypair" {
  description = "AWS EC2 Key pair that need to be associated with EC2 Instance"
  type        = string
  default     = "aug-key-pair"
}

# Input Variables
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-2"
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
  default     = "mgmt"
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