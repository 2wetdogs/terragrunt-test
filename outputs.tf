
output "buckets" {
  value = module.my_s3_bucket.buckets.*.id
}
