# Datasource: EBS CSI IAM Policy get from EBS GIT Repo (latest)
# https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http

# Datasource: AWS Caller Identity
data "aws_caller_identity" "current" {}


data "http" "ebs_csi_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json"
  # https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}
