# S3 bucket for client hosting
resource "aws_s3_bucket" "client_bucket" {
  bucket = "${var.project_name}-client-${var.environment}"

  tags = {
    Name        = "${var.project_name}-client"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# S3 bucket versioning
resource "aws_s3_bucket_versioning" "client_bucket_versioning" {
  bucket = aws_s3_bucket.client_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

# S3 bucket public access block
resource "aws_s3_bucket_public_access_block" "client_bucket_public_access_block" {
  bucket = aws_s3_bucket.client_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket policy
resource "aws_s3_bucket_policy" "client_bucket_policy" {
  bucket = aws_s3_bucket.client_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.client_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" : aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}