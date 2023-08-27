resource "aws_kms_key" "Bits_kms_key" {
  description             = "Bits CMK for S3 encryption"
  deletion_window_in_days = 7
}
