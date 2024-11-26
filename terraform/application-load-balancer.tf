# Create a local variable for the fully qualified domain name
# Combines subdomain and root domain (e.g., app.example.com)
locals {
  fqdn_server = "${var.subdomain_server}.${var.root_domain}"
}

# Look up an existing SSL/TLS certificate in AWS Certificate Manager
data "aws_acm_certificate" "existing_server" {
  domain      = local.fqdn_server # The domain name that the certificate covers
  statuses    = ["ISSUED"]        # Only look for valid certificates that are fully issued
  most_recent = true              # If multiple certificates exist for the domain, use the newest one
}

# Create a DNS A record in Route 53 to point the domain to the ALB
resource "aws_route53_record" "server" {
  zone_id = data.aws_route53_zone.domain.zone_id # The ID of the hosted zone where the record will be created
  name    = local.fqdn_server                    # The domain name for the record (e.g., app.example.com)
  type    = "A"                                  # An A record maps a domain to an IPv4 address

  # Create an alias record (AWS-specific record type that points to AWS resources)
  alias {
    name                   = aws_lb.app_lb.dns_name # The DNS name of the ALB
    zone_id                = aws_lb.app_lb.zone_id  # The canonical hosted zone ID of the ALB
    evaluate_target_health = true                   # Enable health checks for the ALB
  }
}

# Create an Application Load Balancer (ALB)
resource "aws_lb" "app_lb" {
  name               = "${var.project_name}-alb"                        # Name of the ALB
  internal           = false                                            # External load balancer (internet-facing)
  load_balancer_type = "application"                                    # ALB type (supports HTTP/HTTPS)
  security_groups    = [aws_security_group.alb_sg.id]                   # Security group controlling access to the ALB
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id] # Deploy ALB across multiple AZs for high availability

  tags = {
    Name        = "${var.project_name}-alb"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# Create a target group for the ALB
resource "aws_lb_target_group" "app_tg" {
  name     = "${var.project_name}-tg" # Name of the target group
  port     = var.app_port             # Port where your application listens
  protocol = "HTTP"                   # Protocol to use for routing traffic
  vpc_id   = aws_vpc.main.id          # VPC where targets will be registered

  # Configure health checks for the target group
  health_check {
    enabled             = true           # Enable health checks
    healthy_threshold   = 2              # Number of consecutive successful checks required
    interval            = 30             # Time between health checks (seconds)
    matcher             = "200"          # HTTP code indicating healthy target
    path                = "/"            # URL path for health check requests
    port                = "traffic-port" # Use the same port as the application
    timeout             = 5              # Time to wait for a response (seconds)
    unhealthy_threshold = 2              # Number of consecutive failed checks required
  }

  tags = {
    Name        = "${var.project_name}-tg"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# Attach the EC2 instance to the target group
resource "aws_lb_target_group_attachment" "app_tg_attachment" {
  target_group_arn = aws_lb_target_group.app_tg.arn # ARN of the target group
  target_id        = aws_instance.app_server.id     # ID of the EC2 instance
  port             = var.app_port                   # Port where application listens
}

# Create HTTPS listener for the ALB
resource "aws_lb_listener" "front_end_https" {
  load_balancer_arn = aws_lb.app_lb.arn                            # ARN of the ALB
  port              = "443"                                        # HTTPS port
  protocol          = "HTTPS"                                      # HTTPS protocol
  ssl_policy        = "ELBSecurityPolicy-2016-08"                  # AWS SSL security policy
  certificate_arn   = data.aws_acm_certificate.existing_server.arn # ARN of the SSL certificate

  # Forward traffic to the target group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# Create HTTP listener for redirecting to HTTPS
resource "aws_lb_listener" "front_end_http" {
  load_balancer_arn = aws_lb.app_lb.arn # ARN of the ALB
  port              = "80"              # HTTP port
  protocol          = "HTTP"            # HTTP protocol

  # Redirect all HTTP traffic to HTTPS
  default_action {
    type = "redirect"

    redirect {
      port        = "443"      # Redirect to HTTPS port
      protocol    = "HTTPS"    # Redirect to HTTPS protocol
      status_code = "HTTP_301" # Permanent redirect status code
    }
  }
}