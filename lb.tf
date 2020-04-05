resource "aws_lb" "this" {

  name        = "teste"

  load_balancer_type = "application"
  internal           = false
  subnets            = aws_subnet.private.*.id
  security_groups    = [aws_security_group.allow_tls.id]

  lifecycle {
    create_before_destroy = true
  }
  
}
