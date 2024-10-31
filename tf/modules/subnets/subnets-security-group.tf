resource "aws_security_group" "efs" {
  name        = "${var.project_name}-efs-sg"
  description = "Allow inbound EFS traffic from private app and data subnets"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow inbound NFS traffic from app and data subnets"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = concat(aws_subnet.private_app[*].cidr_block, aws_subnet.private_data[*].cidr_block)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-efs-sg"
  }
}