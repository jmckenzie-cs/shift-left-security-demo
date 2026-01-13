# Shift-Left Security Demo - Intentionally Vulnerable Infrastructure
# This template contains multiple security misconfigurations for demonstration

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

# SECURITY ISSUE 1: S3 Bucket with multiple misconfigurations
resource "aws_s3_bucket" "vulnerable_bucket" {
  bucket = "shift-left-demo-bucket-${random_string.bucket_suffix.result}"

  tags = {
    Name        = "VulnerableS3Bucket"
    Environment = var.environment
    Purpose     = "ShiftLeftSecurityDemo"
    SecurityRisk = "High"
  }
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# SECURITY ISSUE 2: Public access block disabled (allows public access)
resource "aws_s3_bucket_public_access_block" "vulnerable_bucket_pab" {
  bucket = aws_s3_bucket.vulnerable_bucket.id

  block_public_acls       = false  # SECURITY ISSUE: Should be true
  block_public_policy     = false  # SECURITY ISSUE: Should be true
  ignore_public_acls      = false  # SECURITY ISSUE: Should be true
  restrict_public_buckets = false  # SECURITY ISSUE: Should be true
}

# SECURITY ISSUE 3: Bucket policy allowing public access
resource "aws_s3_bucket_policy" "vulnerable_bucket_policy" {
  bucket = aws_s3_bucket.vulnerable_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"  # SECURITY ISSUE: Public access
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.vulnerable_bucket.arn}/*"
      },
      {
        Sid       = "PublicListBucket"
        Effect    = "Allow"
        Principal = "*"  # SECURITY ISSUE: Public access
        Action    = "s3:ListBucket"
        Resource  = aws_s3_bucket.vulnerable_bucket.arn
      },
      {
        Sid       = "PublicWriteAccess"
        Effect    = "Allow"
        Principal = "*"  # SECURITY ISSUE: Public write access - extremely dangerous
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.vulnerable_bucket.arn}/*"
      }
    ]
  })
}

# SECURITY ISSUE 4: No versioning enabled (data loss risk)
# Versioning configuration is commented out - missing protection
# resource "aws_s3_bucket_versioning" "vulnerable_bucket_versioning" {
#   bucket = aws_s3_bucket.vulnerable_bucket.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# SECURITY ISSUE 5: No server-side encryption configured
# Encryption configuration is commented out - data at rest not encrypted
# resource "aws_s3_bucket_server_side_encryption_configuration" "vulnerable_bucket_encryption" {
#   bucket = aws_s3_bucket.vulnerable_bucket.id
#
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }

# SECURITY ISSUE 6: IAM Role with excessive permissions
resource "aws_iam_role" "vulnerable_role" {
  name = "VulnerableDemoRole-${var.aws_region}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        # SECURITY ISSUE: No condition restrictions
        # Condition = {
        #   StringEquals = {
        #     "aws:RequestedRegion" = var.aws_region
        #   }
        # }
      }
    ]
  })

  tags = {
    Name         = "VulnerableIAMRole"
    Environment  = var.environment
    Purpose      = "ShiftLeftSecurityDemo"
    SecurityRisk = "Critical"
  }
}

# SECURITY ISSUE 7: Attach overly broad managed policy
resource "aws_iam_role_policy_attachment" "vulnerable_role_attachment" {
  role       = aws_iam_role.vulnerable_role.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"  # SECURITY ISSUE: Too broad
}

# SECURITY ISSUE 8: Inline policy with wildcard permissions
resource "aws_iam_role_policy" "vulnerable_inline_policy" {
  name = "VulnerableDemoPolicy"
  role = aws_iam_role.vulnerable_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "DangerousWildcardAccess"
        Effect   = "Allow"
        Action   = "*"        # SECURITY ISSUE: All actions
        Resource = "*"        # SECURITY ISSUE: All resources
      },
      {
        Sid    = "UnrestrictedAdminAccess"
        Effect = "Allow"
        Action = [
          "iam:*",
          "s3:*",
          "ec2:*",
          "rds:*",
          "lambda:*"
        ]
        Resource = "*"
        # SECURITY ISSUE: Missing condition restrictions
      }
    ]
  })
}

# SECURITY ISSUE 9: IAM User with programmatic access (should use roles instead)
resource "aws_iam_user" "vulnerable_user" {
  name = "demo-user-${var.aws_region}"

  tags = {
    Name         = "VulnerableIAMUser"
    Environment  = var.environment
    SecurityRisk = "Medium"
  }
}

# SECURITY ISSUE 10: Access keys for programmatic access (less secure than roles)
resource "aws_iam_access_key" "vulnerable_access_key" {
  user   = aws_iam_user.vulnerable_user.name
  status = "Active"
  # SECURITY ISSUE: Access keys are less secure than IAM roles
}

# SECURITY ISSUE 11: User policy with broad permissions
resource "aws_iam_user_policy" "vulnerable_user_policy" {
  name = "VulnerableUserPolicy"
  user = aws_iam_user.vulnerable_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = "*"  # SECURITY ISSUE: Should be restricted to specific buckets
      }
    ]
  })
}

# Outputs (some contain sensitive information)
output "bucket_name" {
  description = "Name of the vulnerable S3 bucket"
  value       = aws_s3_bucket.vulnerable_bucket.bucket
}

output "bucket_arn" {
  description = "ARN of the vulnerable S3 bucket"
  value       = aws_s3_bucket.vulnerable_bucket.arn
}

output "iam_role_arn" {
  description = "ARN of the vulnerable IAM role"
  value       = aws_iam_role.vulnerable_role.arn
}

output "access_key_id" {
  description = "Access Key ID for vulnerable user (demo purposes only)"
  value       = aws_iam_access_key.vulnerable_access_key.id
  # SECURITY ISSUE: Outputting sensitive information
}

output "security_issues_count" {
  description = "Number of intentional security issues in this template"
  value       = "11+"
}