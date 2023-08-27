resource "aws_s3_bucket" "bits_bucket_encrypt" {
  bucket = "bits-bucket5505"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.Bits_kms_key.key_id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
