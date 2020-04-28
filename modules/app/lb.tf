resource "aws_lb" "this" {

  name               = local.lb_name
  load_balancer_type = var.lb_type
  internal           = false
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.alb.id]

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

  vpc_id      = var.vpc
  port        = var.http_port
  protocol    = var.http_protocol

  tags = merge(var.tags, local.tags)

  depends_on = [aws_lb.this]

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_launch_configuration" "this" {
  name_prefix     = local.lc_name
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.ec2_type
  key_name        = var.key_pair
  user_data       = var.user_data
  iam_instance_profile = aws_iam_instance_profile.app_profile.name
  security_groups = [aws_security_group.app.id]


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix          = local.asg_name
  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier  = var.private_subnets
  min_size             = 1
  max_size             = 2
  target_group_arns    = [aws_lb_target_group.main.arn]

  tags = [{
        "key"                 = "Name"
        "value"               = var.app_name
        "propagate_at_launch" = true
      },
      {
        "key"                 = "Environment"
        "value"               = var.workspace
        "propagate_at_launch" = true
      }
    ]

  lifecycle {
    create_before_destroy = true
  }
}
