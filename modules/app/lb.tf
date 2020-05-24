resource "aws_lb" "this" {
  count = var.create_lb ? 1 : 0

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
  count = var.create_lb ? 1 : 0

  load_balancer_arn = aws_lb.this.0.arn
  port              = var.http_port
  protocol          = var.http_protocol

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = local.lb_listener_arn

  action {
    type = "forward"
    target_group_arn = local.lb_target_arn
  }

  condition {
    path_pattern {
      values = [local.condition_path]
    }
  }
}


resource "aws_lb_target_group" "main" {

  name        = local.tg_name

  vpc_id      = var.vpc_id
  port        = var.http_port
  protocol    = var.http_protocol

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
    path                = var.health_check_path
    port                = var.health_check_port
  }
  tags = merge(var.tags, local.tags)

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_launch_configuration" "this" {
  name_prefix     = local.lc_name
  image_id        = data.aws_ami.amazon_linux.id
  instance_type   = var.ec2_type
  key_name        = var.key_pair
  user_data       = templatefile(var.user_data, {REPOSITORY_URL=aws_ecr_repository.this.repository_url, BUCKET_NAME=aws_s3_bucket.user_data.id,ACCOUNT_ID=aws_ecr_repository.this.registry_id})
  iam_instance_profile = aws_iam_instance_profile.app_profile.name
  security_groups = [aws_security_group.app.id]

  depends_on = [aws_ecr_repository.this]
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
