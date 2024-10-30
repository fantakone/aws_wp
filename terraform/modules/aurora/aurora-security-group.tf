resource "aws_security_group" "aurora" {
  name        = "${var.project_name}-aurora-sg"
  description = "Security group for Aurora database"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow MySQL traffic from private app subnet"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = var.private_app_subnet_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-aurora-sg"
  }
}