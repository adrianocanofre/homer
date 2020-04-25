resource "aws_security_group" "alb" {
  name        = "alb"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc

  tags = merge(
    var.tags,
    local.tags,
    {
      Name = "allow_http"
    }
  )
}

resource "aws_security_group_rule" "allow_lb_ingress"{
  type = "ingress"
  from_port = var.http_port
  to_port  = var.http_port
  protocol = "tcp"
  security_group_id = aws_security_group.alb.id
  cidr_blocks = [var.all_cidr]
}

resource "aws_security_group_rule" "allow_lb_egress"{
  type = "egress"
  from_port = var.http_port
  to_port  = var.http_port
  protocol = "tcp"
  security_group_id = aws_security_group.alb.id
  source_security_group_id = aws_security_group.app.id
}

resource "aws_security_group" "app" {
  name        = "lb_to_ec2_v2"
  description = "inbound traffic between LB and Ec2"
  vpc_id      = var.vpc

  tags = merge(
    var.tags,
    local.tags,
    {
      Name = "lb_to_ec2"
    }
  )
}

resource "aws_security_group_rule" "lb_to_ec2"{
  type = "ingress"
  from_port = var.http_port
  to_port  = var.http_port
  protocol = "tcp"
  security_group_id = aws_security_group.app.id
  source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "ec2_to_out"{
  type = "egress"
  from_port = var.http_port
  to_port  = var.http_port
  protocol = "tcp"
  security_group_id = aws_security_group.app.id
  cidr_blocks = [var.all_cidr]
}
