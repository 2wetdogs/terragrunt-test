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
  description = "(optional) describe your variable"
}

locals {
  tags = {
    environment = var.environment
    application = var.application
    app_version = var.app_version
  }
}