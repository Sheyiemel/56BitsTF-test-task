#create s3 bucket with versioning and default encryption

resource "aws_s3_bucket" "bits_bucket" {
  bucket = "bitsbybucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bits_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

#create KMS key

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
