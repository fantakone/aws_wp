output "cluster_endpoint" {
  description = "The cluster endpoint"
  value       = aws_rds_cluster.aurora.endpoint
}

output "database_name" {
  description = "The database name"
  value       = aws_rds_cluster.aurora.database_name
}

output "cluster_port" {
  description = "The cluster port"
  value       = aws_rds_cluster.aurora.port
}