resource "aws_lb" "this" {

  name        = "teste"

  load_balancer_type = "application"
  internal           = false
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.allow_tls.id]

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port     = 80
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "HEALTHY"
      status_code  = "200"
    }
  }
}
