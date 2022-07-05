resource "aws_s3_bucket_policy" "bucket" {
  count = length(aws_s3_bucket.buckets)
  bucket   = aws_s3_bucket.buckets[count.index].id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "BUCKET-POLICY"
    Statement = [
      {
        Sid       = "EnforceTls"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          "${aws_s3_bucket.buckets[count.index].arn}/*",
          "${aws_s3_bucket.buckets[count.index].arn}",
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
          NumericLessThan = {
            "s3:TlsVersion" : 1.2
          }
        }
      }
    ]
  })
}