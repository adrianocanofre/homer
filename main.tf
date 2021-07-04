resource "aws_instance" "this" {
  count                  = var.number_ec2
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.ec2_type
  key_name               = var.key_name
  user_data              = var.user_data
  subnet_id              = tolist(data.aws_subnet_ids.private.ids)[count.index]
  vpc_security_group_ids = [aws_security_group.ec2.id]
  tags = {
    Name = var.app_name
  }
}

resource "aws_lb" "this" {
  name               = var.app_name
  internal           = var.lb_internal
  load_balancer_type = var.lb_type
  subnets            = data.aws_subnet_ids.public.ids
  security_groups    = [aws_security_group.lb.id]

}

resource "aws_lb_listener" "this" {

  load_balancer_arn = aws_lb.this.arn
  port              = var.http_port
  protocol          = var.http_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group" "this" {

  name = format("%s-tg-dev", var.app_name)

  vpc_id   = data.aws_vpc.selected.id
  port     = var.http_port
  protocol = var.http_protocol

  dynamic "health_check" {
    for_each = [var.health_check]

    content {
      interval            = health_check.value.interval
      path                = health_check.value.path
      port                = health_check.value.port
      healthy_threshold   = health_check.value.healthy_threshold
      unhealthy_threshold = health_check.value.unhealthy_threshold
      timeout             = health_check.value.timeout
    }
  }

  depends_on = [aws_lb.this]

}


resource "aws_lb_target_group_attachment" "this" {
  count            = var.number_ec2
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = element(aws_instance.this.*.id, count.index)
  port             = var.http_port
}


resource "aws_security_group" "ec2" {
  name        = format("%s-ec2-dev", var.app_name)
  description = format("%s-ec2-dev", var.app_name)
  vpc_id      = data.aws_vpc.selected.id


  tags = {
    Name = format("%s-ec2-dev", var.app_name)
  }
}

resource "aws_security_group" "lb" {
  name        = format("%s-lb-dev", var.app_name)
  description = format("%s-lb-dev", var.app_name)
  vpc_id      = data.aws_vpc.selected.id

  tags = {
    Name = format("%s-lb-dev", var.app_name)
  }
}


resource "aws_security_group_rule" "ec2_inboud" {
  type                     = "ingress"
  description              = "Allow tcp inbound from LB."
  from_port                = var.http_port
  to_port                  = var.http_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb.id
  security_group_id        = aws_security_group.ec2.id
}

resource "aws_security_group_rule" "lb_inboud" {
  type              = "ingress"
  description       = "Allow tcp inbound traffic."
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "lb_out" {
  type                     = "egress"
  description              = "Allow tcp outbound between LB and Ec2."
  from_port                = var.http_port
  to_port                  = var.http_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ec2.id
  security_group_id        = aws_security_group.lb.id
}

resource "aws_security_group_rule" "ec2_out" {
  type              = "egress"
  description       = "Allow tcp outbound traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
}
