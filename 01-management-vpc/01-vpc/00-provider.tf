#####################################################################
# Provider Block
provider "aws" {
  #profile = "default" # AWS Credentials Profile configured on your local desktop terminal  $HOME/.aws/credentials
  region  = var.aws_region
  profile = "992382421476"
}