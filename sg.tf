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
    cidr_blocks = [var.all_cidr]
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
