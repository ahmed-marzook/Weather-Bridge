resource "aws_instance" "app_server" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  key_name      = "weather-wrapper-pem-file"

  vpc_security_group_ids = [aws_security_group.weather_bridge_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              # Update system packages
              yum update -y
              
              # Install base packages
              yum install -y ruby wget java-21-amazon-corretto

              # Install CodeDeploy agent
              wget https://aws-codedeploy-${var.aws_region}.s3.amazonaws.com/latest/install
              chmod +x ./install
              ./install auto
              service codedeploy-agent start
 
              # Install Docker
              yum install -y docker
              systemctl start docker
              systemctl enable docker
              
              # Add EC2 user to docker group
              usermod -a -G docker ec2-user
              
              # Install Docker Compose
              curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              EOF

  tags = {
    Name        = "${var.project_name}-server"
    Environment = var.environment
  }
}