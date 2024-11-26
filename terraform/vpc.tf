# Define the main VPC (Virtual Private Cloud)
# This creates an isolated network environment in AWS
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr # Defines the IP address range for the entire VPC (e.g., 10.0.0.0/16)
  enable_dns_hostnames = true         # Enables DNS hostnames for EC2 instances in the VPC
  enable_dns_support   = true         # Enables DNS support in the VPC

  tags = { # AWS resource tags for organization and billing
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create an Internet Gateway
# This allows resources in your VPC to access the internet and vice versa
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id # Attaches the IGW to your VPC

  tags = {
    Name        = "${var.project_name}-igw"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create first public subnet in Availability Zone A
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id # Associates subnet with your VPC
  cidr_block              = "10.0.1.0/24"   # Subnet's IP range (256 IPs: 10.0.1.0 to 10.0.1.255)
  availability_zone       = "eu-west-2a"    # Places subnet in specific AZ for high availability
  map_public_ip_on_launch = true            # Automatically assigns public IPs to instances in this subnet

  tags = {
    Name        = "${var.project_name}-public-2a"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create second public subnet in Availability Zone B
# This provides redundancy and high availability
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24" # Different IP range from public_a
  availability_zone       = "eu-west-2b"  # Different AZ from public_a
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-2b"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create a Route Table
# This controls network traffic routing within the VPC
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"                  # Route for all external traffic
    gateway_id = aws_internet_gateway.main.id # Send external traffic through the IGW
  }

  tags = {
    Name        = "${var.project_name}-rt"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Associate the Route Table with public subnet A
# This applies the routing rules to the subnet
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id  # The subnet to associate with
  route_table_id = aws_route_table.main.id # The route table to use
}

# Associate the Route Table with public subnet B
resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.main.id
}