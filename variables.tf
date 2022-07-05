variable "aws_region" {
  default = "us-east-2"
}

variable "application" {
  type = string
}

variable "environment" {
  type = string
}

variable "app_version" {
  type = string
}

variable "s3_bucket_names" {
  type        = list(any)
  description = "List of S3 Bucket Names to create.  The names must be less than 56 characters as a dash \"-\" and a 5 digit random number will be added to the end of the bucket name and the bucket name can only be 63 characters."
}

locals {
  tags = {
    environment = var.environment
    application = var.application
    app_version = var.app_version
  }
}