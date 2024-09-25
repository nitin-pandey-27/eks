# STS GET CALLER IDENTITY 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity

data "aws_caller_identity" "current" {}


# IAM Role Resource  
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
/*
resource "aws_iam_role" "this" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
*/


data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["${data.aws_caller_identity.current.arn}"]
    }

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}",
    ]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = ["${data.aws_caller_identity.current.arn}"]
    }

    actions = [
      "s3:GetObject", "s3:PutObject", "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}/*",
    ]
  }
}


###### Create bucket 
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "terraform_state" {
  bucket = local.bucket_name
  lifecycle {
    #prevent_destroy = true    # Comment it to delete it via terraform
  }
  tags = {
    Terraform   = "True"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  depends_on = [aws_s3_bucket.terraform_state]
  bucket     = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  depends_on = [aws_s3_bucket.terraform_state]
  bucket     = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_public_access_block" "terraform_state" {
  depends_on              = [aws_s3_bucket.terraform_state]
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_policy" "terraform_state" {
  depends_on = [aws_s3_bucket.terraform_state]
  bucket     = aws_s3_bucket.terraform_state.id
  policy     = data.aws_iam_policy_document.bucket_policy.json
}

### S3 BUCKET Lifecycle RULES 
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration
## NOTE: The DAYS must be confirmed with the customer.

resource "aws_s3_bucket_lifecycle_configuration" "versioning-bucket-config" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.terraform_state]

  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id = "application-state-rule"
    filter {
      prefix = "application/"
    }

    noncurrent_version_transition {
      noncurrent_days = 30 # 30 days minimum
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 60 # 60 days minimum
      storage_class   = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90 # 90 days 
    }


    status = "Enabled"
  }

  rule {
    id = "monitoring-state-rule"
    filter {
      prefix = "monitoring/"
    }

    noncurrent_version_transition {
      noncurrent_days = 30 # 30 days minimum
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 60 # 60 days minimum
      storage_class   = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90 # 90 days 
    }

    status = "Enabled"
  }

  rule {
    id = "default-rule"
    filter {
      prefix = ""
    }

    noncurrent_version_transition {
      noncurrent_days = 30 # 30 days minimum
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 60 # 60 days minimum
      storage_class   = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90 # 90 days 
    }

    status = "Enabled"
  }
}

##########################
##########################
### S3 BUCKET LOGGING 
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging
## NOTE: You can create a different bucket for bucket logging. Currently I am using the same bucket. 

/*
resource "aws_s3_bucket_logging" "bucket-logging" {

  depends_on = [ aws_s3_bucket.terraform_state ]

  bucket     = aws_s3_bucket.terraform_state.id

  target_bucket = aws_s3_bucket.terraform_state.id

  target_prefix = "${local.bucket_name}-log/bucket-logs/"

}
*/