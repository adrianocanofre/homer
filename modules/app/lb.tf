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

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/api/healthcheck"
    port                = 80
  }
  tags = merge(var.tags, local.tags)

  depends_on = [aws_lb.this]

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_launch_configuration" "this" {
  name_prefix     = local.lc_name
  image_id        = data.aws_ami.amazon_linux.id
  instance_type   = var.ec2_type
  key_name        = var.key_pair
  user_data       = templatefile(var.user_data, {REPOSITORY_URL=aws_ecr_repository.this.repository_url, BUCKET_NAME=aws_s3_bucket.user_data.id})
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
