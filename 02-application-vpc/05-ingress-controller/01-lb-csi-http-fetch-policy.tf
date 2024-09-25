# Datasource: EBS CSI IAM Policy get from EBS GIT Repo (latest)
# https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http

# Datasource: AWS Load Balancer Controller IAM Policy get from aws-load-balancer-controller/ GIT Repo (latest)
data "http" "lbc_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.2/docs/install/iam_policy.json"
  ## url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json"
  # https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html
  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}
