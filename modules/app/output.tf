output "lb_id" {
  description = "The ID of the load balancer."
  value       = aws_lb.this.id
}

output "lb_arn" {
  description = "The ARN of the load balancer."
  value       = aws_lb.this.arn
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.this.dns_name
}

output "ec2_sg" {
  description = "The ID of the app security group."
  value       = aws_security_group.this.*.id,
}
