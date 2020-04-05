resource "aws_lb" "this" {

  name               = local.lb_name
  load_balancer_type = var.lb_type
  internal           = false
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.allow_tls.id]

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.http_port
  protocol          = var.http_protocol

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "HEALTHY"
      status_code  = "200"
    }
  }
}


resource "aws_lb_target_group" "main" {

  name        = local.tg_name

  vpc_id      = aws_vpc.this.id
  port        = var.http_port
  protocol    = var.http_protocol


  depends_on = [aws_lb.this]

  lifecycle {
    create_before_destroy = true
  }
}
