# Create an S3 bucket to store the client/website files
# The bucket name follows the pattern: project-name-client-environment (e.g., weather-bridge-client-prod)
resource "aws_s3_bucket" "client_bucket" {
  bucket = "${var.project_name}-client-${var.environment}"

  # Add identification and management tags to the bucket
  tags = {
    Name        = "${var.project_name}-client" # Identify the bucket's purpose
    Environment = var.environment              # Track which environment this belongs to
    Project     = var.project_name             # Associate with specific project
    ManagedBy   = "terraform"                  # Mark as terraform-managed
  }
}

# Configure versioning settings for the S3 bucket
# Versioning is disabled here since we don't need to maintain file history for static web assets
resource "aws_s3_bucket_versioning" "client_bucket_versioning" {
  bucket = aws_s3_bucket.client_bucket.id # Reference the bucket we just created
  versioning_configuration {
    status = "Disabled" # Turn off versioning to save costs
  }
}

# Set up public access blocking for the S3 bucket
# This is a security best practice - the bucket should only be accessible through CloudFront
resource "aws_s3_bucket_public_access_block" "client_bucket_public_access_block" {
  bucket = aws_s3_bucket.client_bucket.id # Reference the bucket we created

  block_public_acls       = true # Prevent creation of public ACLs
  block_public_policy     = true # Prevent creation of public bucket policies
  ignore_public_acls      = true # Ignore any public ACLs
  restrict_public_buckets = true # Restrict public bucket policies
}

# Define the bucket policy that allows CloudFront to access the bucket
# This creates a secure connection between CloudFront and S3
resource "aws_s3_bucket_policy" "client_bucket_policy" {
  bucket = aws_s3_bucket.client_bucket.id # Reference the bucket we created

  # Use jsonencode to create the policy document
  policy = jsonencode({
    Version = "2012-10-17" # AWS policy version
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal" # Identify the policy statement
        Effect = "Allow"                           # Allow the specified actions
        Principal = {
          Service = "cloudfront.amazonaws.com" # Only CloudFront can access
        }
        Action   = "s3:GetObject"                         # Only allow reading objects
        Resource = "${aws_s3_bucket.client_bucket.arn}/*" # Apply to all objects in bucket

        # Only allow access from our specific CloudFront distribution
        # This prevents other CloudFront distributions from accessing the bucket
        Condition = {
          StringEquals = {
            "AWS:SourceArn" : aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}