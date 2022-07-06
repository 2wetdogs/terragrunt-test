variable "application" {
  type = string
}

variable "environment" {
  type = string
  description = "List of S3 Bucket Names to create.  The names must be less than 50 characters as \"-\" and enviornment(limted to 5 characters) and a \"-\" a 5 digit random number will be added to the end of the bucket name and the bucket name can only be 63 characters."
  validation {
    condition = length(var.environment) <= 5
    error_message = "Environment variable cannot be more than 5 characters"  
  }
}

variable "app_version" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "s3_bucket_names" {
  type        = list(any)
  description = "List of S3 Bucket Names to create.  The names must be less than 50 characters as a dash \"-\" and the enviornment(5 characters or less) and a \"-\" and a 5 digit random number will be added to the end of the bucket name and the bucket name can only be 63 characters."
  validation {
    condition = alltrue([
      for bn in var.s3_bucket_names : length(bn) <= 50
    ])
    error_message = "The names must be less than 50 characters as a dash \"-\" and the enviornment(5 characters or less) and a \"-\" and a 5 digit random number will be added to the end of the bucket name and the bucket name can only be 63 characters."
  }
}

locals {
  tags = {
    environment = var.environment
    application = var.application
    app_version = var.app_version
  }
}
resource "random_integer" "random_integer" {
  min = 10000
  max = 99999
}