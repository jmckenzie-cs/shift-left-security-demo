# Shift-Left Security Demo - CRITICAL ISSUES FIX
# This template fixes the most critical security vulnerabilities

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name for resource tagging"
  type        = string
  default     = "demo"
}

# FIXED: S3 Bucket with proper security configurations
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "shift-left-demo-bucket-${random_string.bucket_suffix.result}"

  tags = {
    Name        = "SecureS3Bucket"
    Environment = var.environment
    Purpose     = "ShiftLeftSecurityDemo"
    SecurityRisk = "Low"
  }
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# FIXED: Block all public access (Critical Fix)
resource "aws_s3_bucket_public_access_block" "secure_bucket_pab" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true   # FIXED: Block public ACLs
  block_public_policy     = true   # FIXED: Block public policies
  ignore_public_acls      = true   # FIXED: Ignore public ACLs
  restrict_public_buckets = true   # FIXED: Restrict public buckets
}

# FIXED: No public bucket policy (removed dangerous public access)
# The vulnerable bucket policy has been completely removed for security

# FIXED: Enable versioning (High Priority Fix)
resource "aws_s3_bucket_versioning" "secure_bucket_versioning" {
  bucket = aws_s3_bucket.secure_bucket.id
  versioning_configuration {
    status = "Enabled"  # FIXED: Enable versioning for data protection
  }
}

# FIXED: Enable server-side encryption (High Priority Fix)
resource "aws_s3_bucket_server_side_encryption_configuration" "secure_bucket_encryption" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"  # FIXED: Enable encryption at rest
    }
    bucket_key_enabled = true
  }
}

# FIXED: Add access logging for security monitoring
resource "aws_s3_bucket_logging" "secure_bucket_logging" {
  bucket = aws_s3_bucket.secure_bucket.id

  target_bucket = aws_s3_bucket.secure_bucket.id
  target_prefix = "access-logs/"
}

# FIXED: IAM Role with least privilege permissions (Critical Fix)
resource "aws_iam_role" "secure_role" {
  name = "SecureDemoRole-${var.aws_region}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        # FIXED: Add condition restrictions
        Condition = {
          StringEquals = {
            "aws:RequestedRegion" = var.aws_region
          }
        }
      }
    ]
  })

  tags = {
    Name         = "SecureIAMRole"
    Environment  = var.environment
    Purpose      = "ShiftLeftSecurityDemo"
    SecurityRisk = "Low"
  }
}

# FIXED: Replace PowerUserAccess with specific, limited permissions
resource "aws_iam_role_policy" "secure_specific_policy" {
  name = "SecureDemoPolicy"
  role = aws_iam_role.secure_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "LimitedS3Access"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.secure_bucket.arn,
          "${aws_s3_bucket.secure_bucket.arn}/*"
        ]
        # FIXED: Add condition restrictions
        Condition = {
          StringEquals = {
            "aws:RequestedRegion" = var.aws_region
          }
        }
      }
    ]
  })
}

# FIXED: Use IAM roles instead of access keys - removed vulnerable IAM user and access keys
# This eliminates the security risk of programmatic access keys

# Secure outputs (no sensitive information exposed)
output "bucket_name" {
  description = "Name of the secure S3 bucket"
  value       = aws_s3_bucket.secure_bucket.bucket
}

output "bucket_arn" {
  description = "ARN of the secure S3 bucket"
  value       = aws_s3_bucket.secure_bucket.arn
}

output "iam_role_arn" {
  description = "ARN of the secure IAM role"
  value       = aws_iam_role.secure_role.arn
}

output "security_improvements" {
  description = "Security improvements implemented"
  value = [
    "S3 bucket public access blocked",
    "Server-side encryption enabled",
    "Versioning enabled",
    "Access logging configured",
    "IAM permissions restricted to least privilege",
    "IAM conditions added for region restriction",
    "Removed dangerous wildcard permissions",
    "Eliminated programmatic access keys",
    "Added proper resource-specific policies"
  ]
}