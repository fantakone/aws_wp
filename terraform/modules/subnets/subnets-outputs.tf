output "private_app_subnet_id" {
  value = aws_subnet.private_app[*].id
}

output "private_data_subnet_ids" {
  value = aws_subnet.private_data[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.public[*].id
}

output "private_app_route_table_id" {
  value = aws_route_table.private_app[*].id
}

output "private_data_route_table_id" {
  value = aws_route_table.private_data[*].id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "efs_id" {
  value = aws_efs_file_system.main.id
}

output "efs_dns_name" {
  value = aws_efs_file_system.main.dns_name
}