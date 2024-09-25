
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
## https://spacelift.io/blog/terraform-dynamodb

resource "aws_dynamodb_table" "dynamodb_table" {
  #name         = local.dynamodb_name
  name         = "terraform_state_lock"    
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Terraform   = "True"
    Environment = var.environment
  }
}


data "aws_iam_policy_document" "dynamodb_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["${data.aws_caller_identity.current.arn}"]
    }

    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]

    resources = [
      #"arn:aws:dynamodb:*:*:table/${local.dynamodb_name}"
      "arn:aws:dynamodb:us-east-2:992382421476:table/terraform_state_lock"
    ]
  }

}

## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_resource_policy

resource "aws_dynamodb_resource_policy" "dynamodb" {
  depends_on   = [aws_dynamodb_table.dynamodb_table, data.aws_iam_policy_document.dynamodb_policy ]
  resource_arn = aws_dynamodb_table.dynamodb_table.arn
  policy       = data.aws_iam_policy_document.dynamodb_policy.json
}