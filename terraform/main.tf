# Define the required providers block - this specifies which providers are needed
# for this Terraform configuration and their versions
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" # The official AWS provider from HashiCorp
      version = "~> 5.0"        # Use version 5.x.x of the provider (~ means allow minor version updates)
    }
  }
}

# Configure the AWS Provider with the specified region
provider "aws" {
  region = var.aws_region # Use a variable for the AWS region instead of hardcoding
}

# Additional provider for us-east-1 (required for ACM with CloudFront)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

# Configure the backend for storing Terraform state remotely
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-ahmed-marzook" # S3 bucket name for storing state
    key            = "weather-bridge-terraform.tfstate"        # Path/name of the state file in the bucket
    region         = "eu-west-2"                               # AWS region where the bucket is located
    encrypt        = true                                      # Enable server-side encryption for the state file
    dynamodb_table = "terraform-state-locks"                   # DynamoDB table for state locking
  }
}