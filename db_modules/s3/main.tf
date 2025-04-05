resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name


  dynamic "versioning" {
    for_each = var.enable_versioning ? [1] : []
    content {
      enabled = true
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_lifecycle" {
  count  = var.enable_lifecycle ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    id     = var.lifecycle_rule.id
    status = var.lifecycle_rule.status

    transition {
      days          = var.lifecycle_rule.transition_days
      storage_class = var.lifecycle_rule.storage_class
    }

    expiration {
      days = var.lifecycle_rule.expiration_days
    }
  }
}
