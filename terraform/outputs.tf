output "public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.app_server.public_ip
}

# output "redis_endpoint" {
#   value = aws_elasticache_cluster.redis_cache.cache_nodes[0].address
# }

# output "redis_port" {
#   value = aws_elasticache_cluster.redis_cache.cache_nodes[0].port
# }

output "vpc_id" {
  value = aws_vpc.main.id
}

# Outputs
output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
  description = "The domain name of the CloudFront distribution"
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.client_bucket.id
  description = "The name of the S3 bucket hosting the client"
}

output "client_url" {
  value       = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
  description = "The URL of the Weather Bridge client application"
}

# output "github_actions_role_arn" {
#   value       = aws_iam_role.github_actions.arn
#   description = "ARN of the GitHub Actions IAM role"
# }