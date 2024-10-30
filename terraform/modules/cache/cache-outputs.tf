output "cache_cluster_id" {
  description = "ID du cluster ElastiCache"
  value       = aws_elasticache_cluster.cache.id
}

output "cache_cluster_address" {
  description = "Adresse du cluster ElastiCache"
  value       = aws_elasticache_cluster.cache.cache_nodes[0].address
}

output "cache_cluster_port" {
  description = "Port du cluster ElastiCache"
  value       = aws_elasticache_cluster.cache.port
}