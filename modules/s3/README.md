#  Overview
This s3 module accepts a list of names for S3 buckets and creates secure S3 buckets with the follwing configuration:

* Bucket versioning is enabled.
* Bucket Server Side Encryption (SSE) is enabled using AES256.
* Block all public access enabled.
* Only allow TLS 1.2 or greater connections.
* Tags added for, env, app, version and Name.


# Examples on how ot use the S3 Module

## Example 1
Using module with no variables in your main terraform project.

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.2.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "my_.aws_profile_name"
}

module "my_s3_bucket" {
    source          = "./modules/s3"
    aws_region      = "us-east-2"
    aws_profile     = "SlalomAzure"
    environment     = "dev"
    application     = "my-app"
    app_version     = "1.0"
    s3_bucket_names = ["mybucket01", "mybucket02"]
}
```



## Example 2
Using module with variables in your main terraform project.  

Variables in main terraform project.
variables.tf
```
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
```

tfvars file in your main terraform project

terraform.tfvars
```
aws_region      = "us-east-2"
aws_profile     = "SlalomAzure"
environment     = "dev"
application     = "my-app"
app_version     = "1.0"
s3_bucket_names = ["mybucket01", "mybucket02"]
```

Passing variables to module.
main.tf
```
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

module "my_s3_bucket" {
    source          = "./modules/s3"
    aws_region      = var.aws_region
    aws_profile     = var.aws_profile
    environment     = var.environment
    application     = var.application
    app_version     = var.app_version
    s3_bucket_names = var.s3_bucket_names
}
```