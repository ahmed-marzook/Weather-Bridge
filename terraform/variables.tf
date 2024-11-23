variable "aws_region" {
  description = "AWS region"
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Project name"
  default     = "weather-bridge"
  type        = string
}

variable "environment" {
  description = "Environment name"
  default     = "production"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "instance_ami" {
  description = "EC2 AMI ID"
  default     = "ami-0b2ed2e3df8cf9080"
}

variable "key_pair_name" {
  description = "Name of the key pair for SSH access"
  default     = "weather-wrapper-pem-file"
}

variable "app_port" {
  description = "Application port"
  default     = 8080
}

variable "ssh_cidr" {
  description = "CIDR block for SSH access"
  default     = "0.0.0.0/0" # Restrict this to your IP in production
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}