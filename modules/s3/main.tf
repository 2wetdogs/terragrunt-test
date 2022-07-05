terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.2.0"
    }
  }
}

resource "aws_s3_bucket" "buckets" {
  count = length(var.s3_bucket_names)
  bucket   = "${var.s3_bucket_names[count.index]}-${random_integer.random_integer.result}"
  tags = {
    env     = var.tags.environment
    app     = var.tags.application
    version = var.tags.app_version
    Name    = "${var.s3_bucket_names[count.index]}-${random_integer.random_integer.result}"
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