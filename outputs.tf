output "lb_dns_name" {
  description = "DNS do load balancer."
  value       = concat(aws_lb.this.*.dns_name, [""])[0]
}
