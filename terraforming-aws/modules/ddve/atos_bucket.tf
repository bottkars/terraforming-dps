resource "random_integer" "atos_bucket_suffix" {
  min = 1
  max = 100000
}

resource "aws_s3_bucket" "atos-bucket" {
  bucket = "${var.environment}-atos-bucket-${random_integer.atos_bucket_suffix.result}"
  force_destroy = true  
  versioning {
    enabled = true
  }
  tags = merge(
    var.tags,
    { "Name" = "${var.environment}-atos-bucket-${random_integer.atos_bucket_suffix.result}" },
  )
}

output "atos_bucket" {
  sensitive = true
  value     = aws_s3_bucket.atos-bucket.bucket
}