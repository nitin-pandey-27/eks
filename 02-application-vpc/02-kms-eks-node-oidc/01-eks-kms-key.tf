# Create KMS Key and Attach Policy 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#tags
# https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-modifying-external-accounts.html

##data "aws_caller_identity" "current" {}

resource "aws_kms_key" "kms_eks_key" {
  description             = "KMS key for EKS Cluster Secret Encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  tags = {
    Name      = "${var.cluster}-${var.vpc_name}-eks"
    Terraform = "true"
  }
  /*
  policy =  <<POLICY
{
  "Version": "2012-10-17",
  "Id": "key-default-1",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
                "AWS": "arn:aws:iam::278671418314:root"
            },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
       ],
      "Resource": "*"
    }
  ],
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
                "AWS": "${data.aws_caller_identity.current.arn}"
            },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
       ],
      "Resource": "*"
    }
  ]
}
POLICY
*/
}

# KMS KEY ALIAS 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias

/*
resource "aws_kms_alias" "kms_eks_key" {
  name          = "alias/kms_eks_key_${var.environment}_${var.cluster}"
  target_key_id = aws_kms_key.kms_eks_key.key_id
}
*/