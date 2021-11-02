resource "aws_s3_bucket" "state_backend" {
  # Bucket names must be unique across all the people & organizations using AWS
  bucket = "terraform-state-bucket-state-backend"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket                  = aws_s3_bucket.state_backend.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}