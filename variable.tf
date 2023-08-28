variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "bitsbybucket"
}

variable "kms_key_alias" {
  description = "Alias for the KMS key"
  type        = string
  default     = "bits_key"
}
