#####################################################################
# Provider Block
provider "aws" {
  #profile = "default" # AWS Credentials Profile configured on your local desktop terminal  $HOME/.aws/credentials
  region  = var.aws_region
  profile = "992382421476"
}

/*

# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#args
provider "kubernetes" {
  #depends_on             = [ data.terraform_remote_state.eks.outputs.cluster_id ]
  host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "--region", "sa-east-1", "--profile", "278671418314_aws-default-dev", "get-token", "--cluster-name", data.terraform_remote_state.eks.outputs.cluster_id]
    command     = "aws"
  }
}

# https://registry.terraform.io/providers/hashicorp/helm/latest/docs
# helm_release - only resource 
# helm_template - only data source

provider "helm" {
  kubernetes {
  #depends_on             = [ data.terraform_remote_state.eks.outputs.cluster_id ]
  host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "--region", "sa-east-1", "--profile", "278671418314_aws-default-dev", "get-token", "--cluster-name", data.terraform_remote_state.eks.outputs.cluster_id]
    command     = "aws"
  }
}
}
*/


# Explanation of above provider configuration
#data.terraform_remote_state.eks.outputs.cluster_endpoint
/*
data --> data block
terraform_remote_state --> resource type for terraform data source provider
eks   --> resource lable 
outputs --> required paramter
cluster_endpoint --> name of the output variable in remote state file which is being imported by terraform_remote_state
*/
