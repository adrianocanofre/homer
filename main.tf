# resource "aws_instance" "this" {
#   count                  = var.number_ec2
#   ami                    = data.aws_ami.ubuntu.id
#   instance_type          = var.ec2_type
#   key_name               = var.key_name
#   user_data              = var.user_data
#   subnet_id              = tolist(data.aws_subnet_ids.private.ids)[count.index]
#   vpc_security_group_ids = [aws_security_group.ec2.id]
#   tags = {
#     Name = var.app_name
#   }
# }

resource "aws_lb" "this" {
  name               = local.app_name
  internal           = var.lb_internal
  load_balancer_type = var.lb_type
  subnets            = data.aws_subnet_ids.public.ids
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
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = aws_lb_listener.this.arn

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  # condition {
  #   path_pattern {
  #     values = [local.condition_path]
  #   }
  # }
}

resource "aws_lb_target_group" "this" {
  name = local.tg_name

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

  tags = merge(var.tags, local.tags)
  depends_on = [aws_lb.this]

  lifecycle {
    create_before_destroy = true
  }

}

# resource "aws_lb_target_group_attachment" "this" {
#   count            = var.number_ec2
#   target_group_arn = aws_lb_target_group.this.arn
#   target_id        = element(aws_instance.this.*.id, count.index)
#   port             = var.http_port
# }


resource "aws_launch_configuration" "this" {
  name_prefix     = local.app_name
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.ec2_type
  key_name        = var.key_pair
  security_groups = [aws_security_group.ec2.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix          = local.app_name
  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier  = data.aws_subnet_ids.public.ids
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  desired_capacity     = var.asg_desired_capacity
  target_group_arns    = [aws_lb_target_group.this.arn]

  tags = [{
        "key"                 = "Name"
        "value"               = var.app_name
        "propagate_at_launch" = true
      },
      {
        "key"                 = "environment"
        "value"               = var.workspace
        "propagate_at_launch" = true
      }
    ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "ec2" {
  name        = format("%s-ec2-%s", var.app_name, var.workspace)
  description = format("%s-ec2-%s", var.app_name, var.workspace)
  vpc_id      = data.aws_vpc.selected.id


  tags = {
    Name = format("%s-ec2-%s", var.app_name, var.workspace)
  }
}

resource "aws_security_group" "lb" {
  name        = format("%s-lb-%s", var.app_name, var.workspace)
  description = format("%s-lb-%s", var.app_name, var.workspace)
  vpc_id      = data.aws_vpc.selected.id

  tags = {
    Name = format("%s-lb-%s", var.app_name, var.workspace)
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
