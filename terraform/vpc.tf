resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr # Use the variable here
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "weather-bridge-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "weather-bridge-igw"
  }
}

# Single Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-2a" # Changed to a valid London AZ
  map_public_ip_on_launch = true

  tags = {
    Name = "weather-bridge-public"
  }
}

# Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "weather-bridge-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.main.id
}