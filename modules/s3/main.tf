terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}
resource "aws_s3_bucket" "buckets" {
  count = length(var.s3_bucket_names)
  bucket   = "${var.s3_bucket_names[count.index]}-${var.environment}-${random_integer.random_integer.result}"
  tags = {
    env     = var.environment
    app     = var.application
    version = var.app_version
    Name    = "${var.s3_bucket_names[count.index]}-${var.environment}-${random_integer.random_integer.result}"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  count = length(aws_s3_bucket.buckets)
  bucket   = aws_s3_bucket.buckets[count.index].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt" {
  count = length(aws_s3_bucket.buckets)
  bucket   = aws_s3_bucket.buckets[count.index].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block_access" {
  count = length(aws_s3_bucket.buckets)
  bucket   = aws_s3_bucket.buckets[count.index].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

resource "aws_s3_bucket_policy" "bucket" {
  count = length(aws_s3_bucket.buckets)
  bucket   = aws_s3_bucket.buckets[count.index].id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "BUCKET-POLICY"
    Statement = [
      {
        Sid       = "EnforceTls"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          "${aws_s3_bucket.buckets[count.index].arn}/*",
          "${aws_s3_bucket.buckets[count.index].arn}",
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
          NumericLessThan = {
            "s3:TlsVersion" : 1.2
          }
        }
      }
    ]
  })
}