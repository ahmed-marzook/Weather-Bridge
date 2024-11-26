# Create a fully qualified domain name (FQDN) by combining subdomain and root domain
# Example: weather-bridge.kaizenflow.dev
locals {
  fqdn = "${var.subdomain_client}.${var.root_domain}"
}

# Look up an existing SSL/TLS certificate in AWS Certificate Manager
# IMPORTANT: Must use us-east-1 region for CloudFront compatibility
data "aws_acm_certificate" "existing_client" {
  provider    = aws.us_east_1 # Use us-east-1 region specifically for CloudFront
  domain      = local.fqdn    # The domain name on the certificate
  statuses    = ["ISSUED"]    # Only find valid certificates
  most_recent = true          # If multiple certificates exist, use the newest one
}

# Look up an existing Route 53 hosted zone for the domain
data "aws_route53_zone" "domain" {
  name         = var.root_domain # The root domain name (e.g., kaizenflow.dev)
  private_zone = false           # Look for public hosted zone, not VPC private zone
}

# Create a DNS record pointing the subdomain to the CloudFront distribution
resource "aws_route53_record" "client" {
  zone_id = data.aws_route53_zone.domain.zone_id # The hosted zone where record will be created
  name    = local.fqdn                           # The full subdomain name
  type    = "A"                                  # Create an A record (maps to IPv4)

  # Create an alias record (AWS-specific record that points to AWS resources)
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name    # CloudFront distribution URL
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id # CloudFront's zone ID
    evaluate_target_health = false                                                      # Don't check target health
  }
}

# Set up Origin Access Control for secure S3 bucket access
# This is the newer, more secure replacement for Origin Access Identity (OAI)
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.project_name}-client-oac"
  description                       = "Origin Access Control for Weather Bridge client"
  origin_access_control_origin_type = "s3"     # This OAC is for S3 buckets
  signing_behavior                  = "always" # Always sign requests to S3
  signing_protocol                  = "sigv4"  # Use AWS Signature Version 4
}

# Create the CloudFront distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled             = true             # Distribution is active
  is_ipv6_enabled     = true             # Support IPv6
  default_root_object = "index.html"     # Serve this file when root path is requested
  price_class         = "PriceClass_100" # Use only NA and EU edge locations (cheapest)
  comment             = "Weather Bridge Client Distribution"
  aliases             = [local.fqdn] # Alternative domain names for the distribution

  # Configure the S3 bucket as the origin
  origin {
    domain_name              = aws_s3_bucket.client_bucket.bucket_regional_domain_name # S3 bucket domain
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id             # Link to OAC
    origin_id                = "S3Origin"                                              # Unique identifier
  }

  # Configure how CloudFront handles requests
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"] # HTTP methods allowed
    cached_methods         = ["GET", "HEAD"]            # Methods that can be cached
    target_origin_id       = "S3Origin"                 # Which origin this applies to
    viewer_protocol_policy = "redirect-to-https"        # Force HTTPS
    compress               = true                       # Enable compression

    # Configure what's included in the cache key
    forwarded_values {
      query_string = false # Don't include query strings in cache key
      cookies {
        forward = "none" # Don't include cookies in cache key
      }
    }

    # Cache duration settings (in seconds)
    min_ttl     = 0     # Minimum time to live in cache
    default_ttl = 3600  # Default time (1 hour)
    max_ttl     = 86400 # Maximum time (24 hours)
  }

  # Handle SPA routing by returning index.html for 403/404 errors
  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  # Geographic restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none" # No geographic restrictions
    }
  }

  # SSL/TLS certificate configuration
  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.existing_client.arn # Use existing certificate
    minimum_protocol_version = "TLSv1.2_2021"                               # Minimum TLS version
    ssl_support_method       = "sni-only"                                   # Use SNI (cheaper than dedicated IP)
  }

  # Resource tagging
  tags = {
    Name        = "${var.project_name}-client-distribution"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}