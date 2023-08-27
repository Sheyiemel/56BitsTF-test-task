resource "aws_s3_bucket" "bits_bucket" {
  bucket = "bits-bucket5505"
  acl    = "private"

  versioning {
    enabled = true
  }
}
