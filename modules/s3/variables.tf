variable "s3_bucket_names" {
  type    = list
  default = []
}

variable "environment" {
  type = string
}

variable "tags" {
  type = object({
    environment     = string
    application     = string
    app_version = string
  })
}

resource "random_integer" "random_integer" {
  min = 10000
  max = 99999
}