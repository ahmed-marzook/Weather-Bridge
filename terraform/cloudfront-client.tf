locals {
  fqdn = "${var.subdomain_client}.${var.root_domain}"
}

# Data source for existing ACM certificate
data "aws_acm_certificate" "existing" {
  provider    = aws.us_east_1
  domain      = local.fqdn
  statuses    = ["ISSUED"]
  most_recent = true
}

# Data source for Route 53 zone
data "aws_route53_zone" "domain" {
  name         = var.root_domain
  private_zone = false
}

# Route 53 A record for CloudFront
resource "aws_route53_record" "client" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = local.fqdn
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.project_name}-client-oac"
  description                       = "Origin Access Control for Weather Bridge client"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100"
  comment             = "Weather Bridge Client Distribution"
  aliases             = [local.fqdn]

  origin {
    domain_name              = aws_s3_bucket.client_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = "S3Origin"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3Origin"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

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

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.existing.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  tags = {
    Name        = "${var.project_name}-client-distribution"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}