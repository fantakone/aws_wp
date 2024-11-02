resource "aws_db_subnet_group" "aurora" {
  name       = "${var.project_name}-aurora-subnet-group"
  subnet_ids = var.private_data_subnet_ids

lifecycle {
    create_before_destroy = false
    ignore_changes        = [name, description, subnet_ids]
  }
  tags = {
    Name = "${var.project_name}-aurora-subnet-group"
  }
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "${var.project_name}-aurora-cluster"
  skip_final_snapshot = true
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.11.2"
  availability_zones      = var.availability_zones
  database_name           = var.database_name
  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = 5
  preferred_backup_window = "03:00-05:00"
  db_subnet_group_name    = aws_db_subnet_group.aurora.name
  vpc_security_group_ids  = [aws_security_group.aurora.id]

  # Lifecycle settings to avoid re-creation
  lifecycle {
    ignore_changes = [
      engine_version,  // Ignores engine version changes
      master_password  // Ignores changes to the master password
    ]
  }
  depends_on = [aws_db_subnet_group.aurora]

}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count                = 2
  identifier           = "${var.project_name}-aurora-instance-${count.index + 1}"
  cluster_identifier   = aws_rds_cluster.aurora.id
  instance_class       = var.instance_class
  engine               = aws_rds_cluster.aurora.engine
  engine_version       = aws_rds_cluster.aurora.engine_version
  publicly_accessible  = false

   # Lifecycle settings to avoid re-creation
  lifecycle {
    ignore_changes = [
      instance_class  // Ignores changes to the instance class
    ]
  }
}
