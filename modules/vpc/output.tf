output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}


output "subnet_public" {
  description = "The ID of the VPC"
  value       = aws_subnet.public.*.id
}

output "subnet_private" {
  description = "The ID of the VPC"
  value       = aws_subnet.private.*.id
}
