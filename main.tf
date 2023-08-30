resource "aws_s3_bucket" "bits_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }
}

# Create KMS key
resource "aws_kms_key" "bits_key" {
  description             = "Customer managed key for S3 bucket encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-default-1",
    Statement = [
      {
        Sid    = "Enable IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "*"
        },
        Action   = "kms:*",
        Resource = "*",
      },
      {
        Sid    = "Allow attachment of persistent resources",
        Effect = "Allow",
        Principal = {
          AWS = "*"
        },
        Action   = "kms:CreateGrant",
        Resource = "*",
        Condition = {
          Bool = {
            "kms:GrantIsForAWSResource" = "true",
          },
        },
      },
      {
        Sid    = "AllowKeyTagging",
        Effect = "Allow",
        Principal = {
          AWS = "*"
        },
        Action   = "kms:TagResource",
        Resource = "*",
        Condition = {
          Bool = {
            "kms:GrantIsForAWSResource" = "true",
          },
        },
      },
    ],
  })

  tags = {
    Name = var.kms_key_alias
  }
}

resource "aws_s3_bucket_policy" "bits_bucket_policy" {
  bucket = aws_s3_bucket.bits_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "RequireEncryption",
        Effect    = "Deny",
        Principal = "*",
        Action    = "s3:PutObject",
        Resource  = "${aws_s3_bucket.bits_bucket.arn}/*",
        Condition = {
          StringNotEqualsIfExists = {
            "s3:x-amz-server-side-encryption-aws-kms-key-id" = aws_kms_key.bits_key.key_id
          }
        }
      },
    ],
  })
}
