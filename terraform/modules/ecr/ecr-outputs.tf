output "repository_url" {
  description = "L'URL du repository ECR"
  value       = aws_ecr_repository.main.repository_url
}

output "repository_name" {
  description = "Le nom du repository ECR"
  value       = aws_ecr_repository.main.name
}