resource "aws_elasticache_subnet_group" "cache" {
  name       = "${var.project_name}-cache-subnet-group"
  subnet_ids = var.private_data_subnet_ids
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elasticache_cluster" "cache" {
  cluster_id           = "${var.project_name}-cache"
  engine               = "memcached"
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = "default.memcached1.6"
  port                 = 11211
  subnet_group_name    = aws_elasticache_subnet_group.cache.name
  security_group_ids   = [aws_security_group.cache.id]
}