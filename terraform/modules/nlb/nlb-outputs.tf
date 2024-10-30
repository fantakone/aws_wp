output "nlb_dns_name" {
  description = "The DNS name of the NLB"
  value       = aws_lb.nlb.dns_name
}

output "nlb_arn" {
  description = "The ARN of the NLB"
  value       = aws_lb.nlb.arn
}

output "target_group_arn" {
  description = "The ARN of the Target Group"
  value       = aws_lb_target_group.nlb_tg.arn
}