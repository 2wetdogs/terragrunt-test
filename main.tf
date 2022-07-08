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
