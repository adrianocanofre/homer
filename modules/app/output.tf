output "lb_id" {
  description = "The ID of the load balancer."
  value       = aws_lb.this.0.id
}

output "lb_arn" {
  description = "The ARN of the load balancer."
  value       = aws_lb.this.0.arn
}


output "target_arn" {
  value = aws_lb_target_group.main.arn
}

output "lb_listener_arn" {
  value = aws_lb_listener.this.0.arn
}

output "sg_ec2" {
  description = "The ID of the app security group."
  value       = aws_security_group.app.id
}

output "sg_lb" {
  description = "The ID of the app security group."
  value       = aws_security_group.alb.id
}
