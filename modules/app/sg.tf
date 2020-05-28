resource "aws_security_group" "alb" {
  name        = format("[%s]-[%s]-alb",var.workspace, var.app_name)
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    local.tags,
    {
      Name = format("%s-allow_http",var.workspace)
    }
  )
}

resource "aws_security_group_rule" "allow_lb_ingress"{
  type              = "ingress"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = "tcp"
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = [var.all_cidr]
  description       = "Default Rule"
}

resource "aws_security_group_rule" "allow_lb_egress"{
  type                     = "egress"
  from_port                = var.e_port
  to_port                  = var.e_port
  protocol                 = var.e_protocol
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = aws_security_group.app.id
  description              = "Default Rule"
}

resource "aws_security_group" "app" {
  name        = format("[%s][%s]lb_to_ec2",var.workspace,var.app_name)
  description = "inbound traffic between LB and Ec2"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    local.tags,
    {
      Name = format("%s-lb_to_ec2", var.workspace)
    }
  )
}

resource "aws_security_group_rule" "lb_to_ec2"{
  type                     = "ingress"
  from_port                = var.e_port
  to_port                  = var.e_port
  protocol                 = var.e_protocol
  security_group_id        = aws_security_group.app.id
  source_security_group_id = aws_security_group.alb.id
  description              = "Default Rule"
}

### SG between Apps ###

resource "aws_security_group_rule" "e_ec2_to_lb"{
  count = var.sg_app == null ? 0 : 1

  type                     = "egress"
  from_port                = var.e_port
  to_port                  = var.e_port
  protocol                 = var.e_protocol
  security_group_id        = aws_security_group.app.id
  source_security_group_id = var.sg_app
  description              = "Default Rule"
}

resource "aws_security_group_rule" "i_lb_to_ec2"{
  count = var.sg_app == null ? 0 : 1

  type                     = "ingress"
  from_port                = var.e_port
  to_port                  = var.e_port
  protocol                 = var.e_protocol
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = var.sg_app
  description              = "Default Rule"
}


### SG by User For Ec2###

resource "aws_security_group" "ec2_by_user" {
  count = var.e_rule == null ? 0 : 1

  name        = local.sg_by_user_name
  description = var.sg_by_user_description

  dynamic "egress" {
    for_each = var.e_rule
    content {
      from_port = egress.value["from_port"]
      to_port   = egress.value["to_port"]
      protocol  = egress.value["protocol"]
      cidr_blocks = egress.value["cidr_blocks"]
      description   = egress.value["description"]
    }
  }
}
