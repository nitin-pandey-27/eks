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
  default     = "demo"
}
# Cluster Variable
variable "cluster" {
  description = "Cluster Variable used as a prefix"
  type        = string
  default     = "mgmt-cluster"
}
# Business Division
variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "oai"
}

# VPC Input Variables
# VPC Name
variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "cluster-1"
}

# VPC CIDR Block
variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type        = string
  default     = "172.21.0.0/16"
}

# Used dynamic data source in 01-vpc-module.tf file. Hence commenting this decalaration. 
# VPC Availability Zones
variable "aws_availability_zones" {
  description = "VPC Availability Zones"
  type        = list(string)
  default     = ["sa-east-1a", "sa-east-1c"]
  #t3.micro is not available in sa-east-1b
}


# VPC Public Subnets
variable "vpc_public_subnets" {
  description = "VPC Public Subnets"
  type        = list(string)
  default     = ["172.21.8.0/23", "172.21.16.0/23"]
}

# VPC Private Subnets
variable "vpc_private_subnets" {
  description = "VPC Private Subnets"
  type        = list(string)
  default     = ["172.21.24.0/22", "172.21.32.0/22"]
}

# VPC Private Subnets
variable "vpc_elasticache_subnets" {
  description = "VPC Cache Subnets"
  type        = list(string)
  default     = ["172.21.40.0/26", "172.21.48.0/26"]
}

