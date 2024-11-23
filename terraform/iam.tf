# # Create IAM Role for GitHub Actions
# resource "aws_iam_role" "github_actions" {
#   name = "weather-bridge-github-actions"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRoleWithWebIdentity"
#         Effect = "Allow"
#         Principal = {
#           Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
#         }
#         Condition = {
#           StringLike = {
#             "token.actions.githubusercontent.com:sub" : "repo:YourGithubUsername/YourRepoName:*"
#           }
#           StringEquals = {
#             "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
#           }
#         }
#       }
#     ]
#   })

#   tags = {
#     Name        = "weather-bridge-github-actions"
#     Environment = var.environment
#     Project     = var.project_name
#     ManagedBy   = "terraform"
#   }
# }

# # Create IAM Policy for S3 and CloudFront access
# resource "aws_iam_role_policy" "github_actions" {
#   name = "weather-bridge-github-actions-policy"
#   role = aws_iam_role.github_actions.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "s3:PutObject",
#           "s3:GetObject",
#           "s3:ListBucket",
#           "s3:DeleteObject"
#         ]
#         Resource = [
#           aws_s3_bucket.client_bucket.arn,
#           "${aws_s3_bucket.client_bucket.arn}/*"
#         ]
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "cloudfront:CreateInvalidation"
#         ]
#         Resource = [
#           aws_cloudfront_distribution.s3_distribution.arn
#         ]
#       }
#     ]
#   })
# }

# # Get current AWS account ID
# data "aws_caller_identity" "current" {}