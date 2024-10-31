output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}
output "internet_gateway_id" {
  value = aws_internet_gateway.main.id
}

output "wordpress_security_group_id" {
  value = aws_security_group.wordpress.id
}