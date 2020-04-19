resource "aws_lb" "this" {

  name               = local.lb_name
  load_balancer_type = var.lb_type
  internal           = false
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.lb.id]

  tags = merge(var.tags, local.tags)
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.http_port
  protocol          = var.http_protocol

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}


resource "aws_lb_target_group" "main" {

  name        = local.tg_name

  vpc_id      = aws_vpc.this.id
  port        = var.http_port
  protocol    = var.http_protocol

  tags = merge(var.tags, local.tags)

  depends_on = [aws_lb.this]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.nginx.id
  port             = 80
}
