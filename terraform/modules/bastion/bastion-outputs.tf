output "bastion_asg_id" {
  description = "ID of the Auto Scaling Group for the Bastion host"
  value       = aws_autoscaling_group.bastion.id
}

output "bastion_asg_name" {
  description = "Name of the Auto Scaling Group for the Bastion host"
  value       = aws_autoscaling_group.bastion.name
}

output "bastion_sg_id" {
  description = "Security Group ID of the Bastion host"
  value       = aws_security_group.bastion_sg.id
}

output "bastion_launch_template_id" {
  description = "ID of the Launch Template for the Bastion host"
  value       = aws_launch_template.bastion.id
}

output "bastion_key_name" {
  description = "Name of the SSH key pair used for the Bastion host"
  value       = aws_key_pair.bastion_keys.key_name
}