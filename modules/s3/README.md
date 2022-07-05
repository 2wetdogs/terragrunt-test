# Examples on how ot use the S3 Module

## Example 1

```
module "my_s3_bucket" {
  source          = "./modules/s3"
  s3_bucket_names = ["test1", "test2"]
  environment     = "dev"
  tags            = {
    environment = "dev"
    application = "My Super Fun App!"
    app_version = "1.0"
  }
}
```



## Example 2
Using Variables in your main terraform project.

Variables in main terraform structure.
```
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
```

tfvars file in your main terraform project.
```
environment     = "dev"
application     = "My Super Fun App!"
app_version     = "1.0"
s3_bucket_names = ["test1", "test2"]
```

Passing variables to module.
```
module "my_s3_bucket" {
  source          = "./modules/s3"
  s3_bucket_names = var.s3_bucket_names
  environment     = var.environment
  tags            = local.tags
}
```