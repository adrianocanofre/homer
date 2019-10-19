resource "aws_lb" "front_end" {
  name               = "${var.lb_name}"
  internal           = "${var.is_internal}"
  load_balancer_type = "${var.type_lb}"
  subnets            = ["${var.subnets}"]
  security_groups    = ["${var.security_groups}"]
  enable_deletion_protection = true

}

resource "aws_lb_listener" "https" {
  load_balancer_arn = "${aws_lb.front_end.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "${var.ssl_policy}"
  certificate_arn   = "${var.acm_lb_corp}"

  default_action {
      type = "fixed-response"

      fixed_response {
        content_type = "text/plain"
        message_body = "Fixed response content"
        status_code  = "200"
      }
    }
  }


resource "aws_security_group" "alb_cip" {
  name        = "${var.sg_alb_name}"
  description = "${var.sg_alb_description}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.i_ip_range}"]
    description = "${var.ingress_description}"
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.e_ip_range}"]
  }

  tags = "${var.sg_alb_tags}"
}

output "listener_arn" {
  value = "${aws_lb_listener.https.arn}"
}

output "lb" {
  value = {
    dns_name   = "${aws_lb.front_end.dns_name}"
    zone_id    = "${aws_lb.front_end.zone_id}"
  }
}
