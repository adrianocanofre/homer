resource "aws_instance" "this" {
  count                  = 2
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.ec2_type
  key_name               = var.key_name
  user_data              = file("scripts/userdata.sh")
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
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = var.http_port
  }

  depends_on = [aws_lb.this]

}


resource "aws_lb_target_group_attachment" "this" {
  count            = 2
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = element(aws_instance.this.*.id, count.index)
  port             = var.http_port
}


resource "aws_security_group" "ec2" {
  name        = format("%s-ec2-dev", var.app_name)
  description = "homer-ec2"
  vpc_id      = data.aws_vpc.selected.id


  tags = {
    Name = format("%s-ec2-dev", var.app_name)
  }
}

resource "aws_security_group" "lb" {
  name        = format("%s-lb-dev", var.app_name)
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.selected.id

  tags = {
    Name = format("%s-lb-dev", var.app_name)
  }
}


resource "aws_security_group_rule" "ec2_inboud" {
  type                     = "ingress"
  description              = "HTTP from LB"
  from_port                = var.http_port
  to_port                  = var.http_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb.id
  security_group_id        = aws_security_group.ec2.id
}

resource "aws_security_group_rule" "lb_inboud" {
  type              = "ingress"
  description       = "Allow tcp inbound traffic"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "lb_out" {
  type                     = "egress"
  description              = "Traffic between LB and Ec2"
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
