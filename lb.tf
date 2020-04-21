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


resource "aws_launch_configuration" "this" {
  name_prefix     = local.lc_name
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  key_name        = var.key_pair
  user_data       = file("files/install_nginx.sh")
  security_groups = [aws_security_group.ec2.id]


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix          = local.asg_name
  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier  = aws_subnet.private.*.id
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
        "value"               = local.env
        "propagate_at_launch" = true
      }
    ]

  lifecycle {
    create_before_destroy = true
  }
}
