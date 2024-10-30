resource "aws_security_group" "cache" {
  name        = "${var.project_name}-cache-sg"
  description = "Security group for ElastiCache"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow Memcached traffic from private app subnet"
    from_port       = 11211
    to_port         = 11211
    protocol        = "tcp"
    cidr_blocks     = [var.private_app_subnet_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-cache-sg"
  }
}