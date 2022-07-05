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
}

module "my_s3_bucket" {
  source          = "./modules/s3"
  s3_bucket_names = var.s3_bucket_names
  environment     = var.environment
  tags            = local.tags
}
