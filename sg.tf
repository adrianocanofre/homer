resource "aws_security_group" "lb" {
  name        = "allow_lb"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "TLS from VPC"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }

  egress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    security_groups = [var.all_cidr]
  }

  tags = merge(
    var.tags,
    local.tags,
    {
      Name = "allow_http"
    }
  )
}

resource "aws_security_group" "ec2" {
  name        = "lb_to_ec2"
  description = "inbound traffic between LB and Ec2"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "TLS from VPC"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_cidr]
  }

  tags = merge(
    var.tags,
    local.tags,
    {
      Name = "lb_to_ec2"
    }
  )
}

resource "aws_security_group" "alb" {
  name        = "alb"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.this.id

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
  vpc_id      = aws_vpc.this.id

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
