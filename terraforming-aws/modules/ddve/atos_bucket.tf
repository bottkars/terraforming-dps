resource "random_integer" "atos_bucket_suffix" {
  min = 1
  max = 100000
}

resource "aws_s3_bucket" "atos-bucket" {
  bucket = "${var.environment}-atos-bucket-${random_integer.atos_bucket_suffix.result}"
  force_destroy = true  
  tags = merge(
    var.tags,
    { "Name" = "${var.environment}-atos-bucket-${random_integer.atos_bucket_suffix.result}" },
  )
}


resource "aws_s3_bucket_versioning" "atos-bucket-versioning" {
  bucket = aws_s3_bucket.atos-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


output "atos_bucket" {
  sensitive = true
  value     = aws_s3_bucket.atos-bucket.bucket
}